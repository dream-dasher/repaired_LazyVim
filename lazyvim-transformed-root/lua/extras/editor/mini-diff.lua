-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.diff; Git for its default source.
-- Docs: https://github.com/nvim-mini/mini.diff
-- Enable: require("extras.editor.mini-diff") in init.lua.
-- Remove Gitsigns' vim.pack.add entry, setup, and maps from plugins/editor.lua before enabling this alternative.
-- Conflicts: Git sign providers should be exclusive; core lualine diff must use vim.b.minidiff_summary instead of Gitsigns.
-- Lualine source example: local s=vim.b.minidiff_summary; return s and {added=s.add,modified=s.change,removed=s.delete}.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/nvim-mini/mini.diff" })
local diff = require("mini.diff")
diff.setup({ view = { style = "sign", signs = { add = "▎", change = "▎", delete = "" } } })
vim.keymap.set("n", "<leader>go", function()
  diff.toggle_overlay(0)
end, { desc = "Toggle diff overlay" })
vim.keymap.set("n", "<leader>uG", function()
  vim.g.minidiff_disable = not vim.g.minidiff_disable
  if vim.g.minidiff_disable then
    diff.disable(0)
  else
    diff.enable(0)
  end
end, { desc = "Toggle diff signs" })
