-- Dependencies: git for vim.pack. Manual parser installation needs curl, tar,
-- a C compiler and tree-sitter CLI >= 0.26.1 (install via a system package manager, not npm).
-- Plugins: nvim-treesitter and textobjects (main), nvim-ts-autotag.
-- Manual command: :TSInstall bash c diff html javascript jsdoc json lua luadoc luap
--   markdown markdown_inline printf python query regex toml tsx typescript vim vimdoc xml yaml
-- After updating this plugin, run :TSUpdate yourself to align installed parser revisions.
-- Docs: https://github.com/nvim-treesitter/nvim-treesitter/tree/main
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  "https://github.com/windwp/nvim-ts-autotag",
})
require("nvim-treesitter").setup({})
require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
require("nvim-ts-autotag").setup({})

local moves = {
  goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
  goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
  goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
  goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
}
local function attach(buf)
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  if not lang then
    return
  end
  local loaded, available = pcall(vim.treesitter.language.add, lang)
  if not loaded or not available then
    return
  end
  local function query(name)
    local ok, result = pcall(vim.treesitter.query.get, lang, name)
    return ok and result ~= nil
  end
  if query("highlights") then
    pcall(vim.treesitter.start, buf)
  end
  if query("indents") then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  if query("folds") then
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      if vim.wo[win].foldexpr ~= "v:lua.vim.lsp.foldexpr()" then
        vim.wo[win].foldmethod = "expr"
        vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end
    end
  end
  if query("textobjects") then
    for method, mappings in pairs(moves) do
      for key, capture in pairs(mappings) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          if vim.wo.diff and key:match("[cC]") then
            return vim.cmd("normal! " .. key)
          end
          require("nvim-treesitter-textobjects.move")[method](capture, "textobjects")
        end, { buffer = buf, silent = true, desc = method:gsub("_", " ") .. " " .. capture })
      end
    end
  end
end
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
  callback = function(event)
    attach(event.buf)
  end,
})
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then
    attach(buf)
  end
end
