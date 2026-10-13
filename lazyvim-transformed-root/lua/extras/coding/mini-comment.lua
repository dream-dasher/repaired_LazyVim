-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.comment; nvim-ts-context-commentstring; installed Tree-sitter parsers for contextual comments.
-- Docs: https://github.com/nvim-mini/mini.comment
-- Enable: require("extras.coding.mini-comment") in init.lua.
-- Alternative to native gc comments plus ts-comments: remove ts-comments setup/add from plugins/coding.lua.
-- Conflicts: both own commentstring behavior; choose one contextual-comment plugin.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({
  "https://github.com/nvim-mini/mini.comment",
  "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
})
require("ts_context_commentstring").setup({ enable_autocmd = false })
require("mini.comment").setup({
  options = {
    custom_commentstring = function()
      return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
    end,
  },
})
