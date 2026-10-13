-- Dependencies: Neovim 0.12.6; Git for vim.pack; fzf-lua; fzf executable; rg; fd optional; optional delta for code-action preview.
-- Docs: https://github.com/ibhagwan/fzf-lua
-- Enable: require("extras.editor.fzf") in init.lua.
-- Load AFTER plugins/lsp.lua and config/keymaps.lua; set picker.enabled=false directly in plugins/snacks.lua.
-- Conflicts: choose Snacks, Telescope, or fzf-lua as the default picker; replacements below deliberately own shared keys.
-- No framework picker registration or option injection; vim.ui.select is registered directly.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })
local fzf, map = require("fzf-lua"), vim.keymap.set
fzf.setup({
  "default-title",
  fzf_colors = true,
  fzf_opts = { ["--no-scrollbar"] = true },
  winopts = { width = 0.8, height = 0.8, preview = { scrollchars = { "┃", "" } } },
  files = {
    cwd_prompt = false,
    actions = { ["alt-i"] = fzf.actions.toggle_ignore, ["alt-h"] = fzf.actions.toggle_hidden },
  },
  grep = { actions = { ["alt-i"] = fzf.actions.toggle_ignore, ["alt-h"] = fzf.actions.toggle_hidden } },
  lsp = { code_actions = { previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil } },
})
fzf.register_ui_select()
local function root()
  return require("util.root").get()
end
for _, key in ipairs({ "<leader><space>", "<leader>ff" }) do
  map("n", key, function()
    fzf.files({ cwd = root() })
  end, { desc = "Find files (root)" })
end
for _, key in ipairs({ "<leader>/", "<leader>sg" }) do
  map("n", key, function()
    fzf.live_grep({ cwd = root() })
  end, { desc = "Grep (root)" })
end
map("n", "<leader>fF", function()
  fzf.files({ cwd = vim.uv.cwd() })
end, { desc = "Find files (cwd)" })
map("n", "<leader>sG", function()
  fzf.live_grep({ cwd = vim.uv.cwd() })
end, { desc = "Grep (cwd)" })
map("n", "<leader>fc", function()
  fzf.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find config files" })
map("n", "<leader>fR", function()
  fzf.oldfiles({ cwd = vim.uv.cwd(), cwd_only = true })
end, { desc = "Recent files (cwd)" })
for key, name in pairs({
  [","] = "buffers",
  [":"] = "command_history",
  fb = "buffers",
  fB = "buffers",
  fg = "git_files",
  fr = "oldfiles",
  gc = "git_commits",
  gd = "git_diff",
  gl = "git_commits",
  gs = "git_status",
  gS = "git_stash",
  ['s"'] = "registers",
  ["s/"] = "search_history",
  sa = "autocmds",
  sb = "lines",
  sc = "command_history",
  sC = "commands",
  sd = "diagnostics_workspace",
  sD = "diagnostics_document",
  sh = "help_tags",
  sH = "highlights",
  sj = "jumps",
  sk = "keymaps",
  sl = "loclist",
  sM = "man_pages",
  sm = "marks",
  sR = "resume",
  sq = "quickfix",
  ss = "lsp_document_symbols",
  sS = "lsp_live_workspace_symbols",
  uC = "colorschemes",
}) do
  map("n", "<leader>" .. key, function()
    fzf[name]()
  end, { desc = "Search: " .. name })
end
for key, use_root in pairs({ sw = true, sW = false }) do
  map("n", "<leader>" .. key, function()
    fzf.grep_cword({ cwd = use_root and root() or vim.uv.cwd() })
  end, { desc = "Search word" })
  map("x", "<leader>" .. key, function()
    fzf.grep_visual({ cwd = use_root and root() or vim.uv.cwd() })
  end, { desc = "Search selection" })
end
map("n", "<leader>st", function()
  require("todo-comments.fzf").todo()
end, { desc = "Todo" })
map("n", "<leader>sT", function()
  require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo/Fix" })
local function lsp_maps(buffer)
  for key, name in pairs({
    gd = "lsp_definitions",
    gr = "lsp_references",
    gI = "lsp_implementations",
    gy = "lsp_typedefs",
    ["<leader>ss"] = "lsp_document_symbols",
    ["<leader>sS"] = "lsp_live_workspace_symbols",
  }) do
    map("n", key, function()
      fzf[name]({ jump1 = true, ignore_current_line = true })
    end, { buffer = buffer, desc = "LSP: " .. name })
  end
end
lsp_maps()
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("config_fzf_lsp", { clear = true }),
  callback = function(event)
    lsp_maps(event.buf)
  end,
})
for _, client in ipairs(vim.lsp.get_clients()) do
  for buffer in pairs(client.attached_buffers) do
    lsp_maps(buffer)
  end
end
