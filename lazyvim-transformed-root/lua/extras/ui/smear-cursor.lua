-- Dependencies: Neovim 0.12.6; Git for vim.pack; smear-cursor.nvim; no external executable.
-- Docs: https://github.com/sphamba/smear-cursor.nvim
-- Enable: require("extras.ui.smear-cursor") in init.lua.
-- Disabled in Neovide (it already animates). If using mini-animate, directly set cursor.enable=false in its module.
-- Conflicts: simultaneous cursor animators produce overlapping effects.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

if vim.g.neovide then
  return
end
vim.pack.add({ "https://github.com/sphamba/smear-cursor.nvim" })
require("smear_cursor").setup({ hide_target_hack = true, cursor_color = "none" })
