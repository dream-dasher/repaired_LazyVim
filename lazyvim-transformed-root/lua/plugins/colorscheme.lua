-- External dependencies: none (a Nerd Font is recommended for the surrounding UI).
-- Plugin dependencies: folke/tokyonight.nvim. Manual builds: none.
-- Docs: https://github.com/folke/tokyonight.nvim#configuration
-- TokyoNight writes its generated palette cache under stdpath('cache').
-- Alternative: replace this init.lua call with plugins.catppuccin; choose one theme.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Make the theme available, select its Moon palette, then apply it.
vim.pack.add({ { src = "https://github.com/folke/tokyonight.nvim" } })
require("tokyonight").setup({ style = "moon" })
vim.cmd.colorscheme("tokyonight")
