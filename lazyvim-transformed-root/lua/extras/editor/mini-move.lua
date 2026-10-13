-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.move; no external executable.
-- Docs: https://github.com/nvim-mini/mini.move
-- Enable: require("extras.editor.mini-move") in init.lua.
-- Conflicts: <M-h/j/k/l> replace existing move mappings in normal/visual mode; edit mappings in setup if desired.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/nvim-mini/mini.move" })
require("mini.move").setup({})
