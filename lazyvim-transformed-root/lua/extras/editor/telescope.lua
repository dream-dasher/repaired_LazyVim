-- Dependencies: Neovim 0.12.6; Git for vim.pack; telescope.nvim; plenary.nvim; dressing.nvim; rg; fd optional. Optional telescope-fzf-native needs make/C compiler.
-- Docs: https://github.com/nvim-telescope/telescope.nvim
-- Enable: require("extras.editor.telescope") in init.lua.
-- Load AFTER plugins/lsp.lua and config/keymaps.lua. Directly set picker.enabled=false and input.enabled=false in plugins/snacks.lua.
-- Conflicts: choose Snacks, fzf-lua, or Telescope as the default picker; replacements below deliberately own shared keys.
-- Optional native sorter: uncomment its vim.pack URL, review/run `make` in that checkout manually, then uncomment load_extension('fzf').
-- No plugin builds or automatic rebuilds run here.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load Telescope, its Lua dependency, and input/selection dialogs; the native sorter is optional.
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/stevearc/dressing.nvim",
  -- "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
})
local telescope = require("telescope")
local actions = require("telescope.actions")
-- Configure picker appearance, navigation/history keys, and hidden-file searches through rg.
telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    -- Open selections in the first ordinary buffer window; return 0 to use the current window.
    get_selection_window = function()
      for _, window in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(window)].buftype == "" then
          return window
        end
      end
      return 0
    end,
    mappings = {
      i = {
        ["<C-t>"] = require("trouble.sources.telescope").open,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-b>"] = actions.preview_scrolling_up,
      },
      n = { q = actions.close },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = { "rg", "--files", "--color", "never", "--hidden", "-g", "!.git" },
    },
  },
})
-- telescope.load_extension("fzf") -- only after manual build
-- Route vim.ui.select through Telescope, with the built-in selector as a fallback.
require("dressing").setup({ select = { backend = { "telescope", "builtin" } } })
local builtin, map = require("telescope.builtin"), vim.keymap.set
--- Return the current project root using the shared LSP/marker/cwd fallback rules.
local function root()
  return require("util.root").get()
end
-- Search files and contents relative to the current project root.
for _, key in ipairs({ "<leader><space>", "<leader>ff" }) do
  map("n", key, function()
    builtin.find_files({ cwd = root() })
  end, { desc = "Find files (root)" })
end
for _, key in ipairs({ "<leader>/", "<leader>sg" }) do
  map("n", key, function()
    builtin.live_grep({ cwd = root() })
  end, { desc = "Grep (root)" })
end
-- Provide cwd/config searches, cwd-filtered recent files, current-buffer diagnostics, and theme previews.
map("n", "<leader>fF", function()
  builtin.find_files({ cwd = vim.uv.cwd() })
end, { desc = "Find files (cwd)" })
map("n", "<leader>sG", function()
  builtin.live_grep({ cwd = vim.uv.cwd() })
end, { desc = "Grep (cwd)" })
map("n", "<leader>fc", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find config files" })
map("n", "<leader>fR", function()
  builtin.oldfiles({ cwd = vim.uv.cwd(), cwd_only = true })
end, { desc = "Recent files (cwd)" })
map("n", "<leader>sD", function()
  builtin.diagnostics({ bufnr = 0 })
end, { desc = "Buffer diagnostics" })
map("n", "<leader>uC", function()
  builtin.colorscheme({ enable_preview = true })
end, { desc = "Colorscheme preview" })
-- Bind the remaining buffer, Git, history, diagnostics, and editor-state pickers.
for key, name in pairs({
  [","] = "buffers",
  [":"] = "command_history",
  fb = "buffers",
  fB = "buffers",
  fg = "git_files",
  fr = "oldfiles",
  gc = "git_commits",
  gl = "git_commits",
  gs = "git_status",
  gS = "git_stash",
  ['s"'] = "registers",
  ["s/"] = "search_history",
  sa = "autocommands",
  sb = "current_buffer_fuzzy_find",
  sc = "command_history",
  sC = "commands",
  sd = "diagnostics",
  sh = "help_tags",
  sH = "highlights",
  sj = "jumplist",
  sk = "keymaps",
  sl = "loclist",
  sM = "man_pages",
  sm = "marks",
  so = "vim_options",
  sR = "resume",
  sq = "quickfix",
  ss = "lsp_document_symbols",
  sS = "lsp_dynamic_workspace_symbols",
}) do
  map("n", "<leader>" .. key, function()
    builtin[name]()
  end, { desc = "Search: " .. name })
end
-- Search the cursor word, or preserve the full visual region as the search text.
-- Lowercase keys search the project root; uppercase keys search the current working directory.
for key, use_root in pairs({ sw = true, sW = false }) do
  map({ "n", "x" }, "<leader>" .. key, function()
    local search = vim.fn.expand("<cword>")
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
      search = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode }), "\n")
    end
    builtin.grep_string({ cwd = use_root and root() or vim.uv.cwd(), search = search })
  end, { desc = "Search word/selection" })
end
-- Search all tracked comment keywords, or restrict results to TODO/FIX/FIXME.
map("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
map("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix" })
--- Install picker-based LSP navigation globally, or locally when a buffer is supplied.
--- Reuse an existing window for the selected result when possible.
local function lsp_maps(buffer)
  for key, name in pairs({
    gd = "lsp_definitions",
    gr = "lsp_references",
    gI = "lsp_implementations",
    gy = "lsp_type_definitions",
    ["<leader>ss"] = "lsp_document_symbols",
    ["<leader>sS"] = "lsp_dynamic_workspace_symbols",
  }) do
    map("n", key, function()
      builtin[name]({ reuse_win = true })
    end, { buffer = buffer, desc = "LSP: " .. name })
  end
end
-- Provide global LSP navigation defaults before any client attaches.
lsp_maps()
-- Replace the attaching buffer's core LSP mappings with Telescope navigation.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("config_telescope_lsp", { clear = true }),
  callback = function(event)
    lsp_maps(event.buf)
  end,
})
-- Apply the same local mappings to clients/buffers that were already attached.
for _, client in ipairs(vim.lsp.get_clients()) do
  for buffer in pairs(client.attached_buffers) do
    lsp_maps(buffer)
  end
end
