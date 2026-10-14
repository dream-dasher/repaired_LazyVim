-- Dependencies: git for vim.pack. Manual parser installation needs curl, tar,
-- a C compiler and tree-sitter CLI >= 0.26.1 (install via a system package manager, not npm).
-- Plugins: nvim-treesitter and textobjects (main), nvim-ts-autotag.
-- Manual command: :TSInstall bash c diff html javascript jsdoc json lua luadoc luap
--   markdown markdown_inline printf python query regex toml tsx typescript vim vimdoc xml yaml
-- After updating this plugin, run :TSUpdate yourself to align installed parser revisions.
-- Docs: https://github.com/nvim-treesitter/nvim-treesitter/tree/main
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Load syntax support and text objects; parser downloads and builds are manual.
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  "https://github.com/windwp/nvim-ts-autotag",
})
-- Configure the plugins; movement records jumps and tag editing uses its default filetypes.
require("nvim-treesitter").setup({})
require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
require("nvim-ts-autotag").setup({})

-- Map next/previous starts and ends for functions, classes and parameters.
local moves = {
  goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
  goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
  goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
  goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
}
--- Enable available Tree-sitter features for a buffer without installing its parser.
--- Keep LSP folding when already selected; missing languages, parsers or queries are skipped.
local function attach(buf)
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  if not lang then
    return
  end
  local loaded, available = pcall(vim.treesitter.language.add, lang)
  if not loaded or not available then
    return
  end
  --- Report whether this language has a usable query of the requested kind.
  local function query(name)
    local ok, result = pcall(vim.treesitter.query.get, lang, name)
    return ok and result ~= nil
  end
  -- Each feature needs its own query, so a partial parser setup can still supply useful features.
  if query("highlights") then
    pcall(vim.treesitter.start, buf)
  end
  if query("indents") then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  -- Folding is a window setting; configure each window that currently displays this buffer.
  if query("folds") then
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      if vim.wo[win][0].foldexpr ~= "v:lua.vim.lsp.foldexpr()" then
        vim.wo[win][0].foldmethod = "expr"
        vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end
    end
  end
  -- Add syntax-based movement only to this buffer when text-object captures are available.
  if query("textobjects") then
    for method, mappings in pairs(moves) do
      for key, capture in pairs(mappings) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          -- Preserve native diff motions for the class-jump keys in diff windows.
          if vim.wo.diff and key:match("[cC]") then
            return vim.cmd("normal! " .. key)
          end
          require("nvim-treesitter-textobjects.move")[method](capture, "textobjects")
        end, { buffer = buf, silent = true, desc = method:gsub("_", " ") .. " " .. capture })
      end
    end
  end
end
-- Attach syntax features whenever a buffer's filetype is detected or changed.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
  callback = function(event)
    attach(event.buf)
  end,
})
-- Also attach to buffers already loaded before this module was required.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then
    attach(buf)
  end
end
