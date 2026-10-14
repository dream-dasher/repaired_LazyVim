-- Dependencies: Neovim 0.12.6; Git for vim.pack; leap.nvim (Codeberg); vim-repeat; no external executable.
-- Docs: https://codeberg.org/andyg/leap.nvim
-- Enable: require("extras.editor.leap") in init.lua.
-- Remove Flash's vim.pack.add entry, setup, and maps from plugins/editor.lua before enabling Leap.
-- Conflicts: s/S/gs replace Flash; in mini-surround.lua change gs prefixes to gz.
-- Load after config/keymaps.lua. Keeps native x/X after Leap's default mappings are created.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load Leap and repeat support, then install labeled normal/visual jump mappings.
vim.pack.add({ "https://github.com/tpope/vim-repeat", "https://codeberg.org/andyg/leap.nvim.git" })
local leap = require("leap")
leap.opts.labeled_modes = "nx"
leap.add_default_mappings(true)
-- Remove Leap's x/X mappings so the native operations remain available; absent maps are harmless.
pcall(vim.keymap.del, { "x", "o" }, "x")
pcall(vim.keymap.del, { "x", "o" }, "X")
