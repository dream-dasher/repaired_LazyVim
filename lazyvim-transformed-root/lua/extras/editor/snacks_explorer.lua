-- Dependencies: Neovim 0.12.6; Git for vim.pack; Snacks (already installed/configured in plugins/snacks.lua).
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
-- Enable: require("extras.editor.snacks_explorer") in init.lua.
-- Already enabled by default; optional alias maps below need plugins/snacks.lua first.
-- Conflicts: Neo-tree replaces these keys; choose one module for <leader>e/E.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Open the configured Snacks explorer at project root/cwd and expose shorter aliases.
vim.keymap.set("n", "<leader>fe", function()
  Snacks.explorer({ cwd = require("util.root").get() })
end, { desc = "Explorer (root)" })
vim.keymap.set("n", "<leader>fE", function()
  Snacks.explorer({ cwd = vim.uv.cwd() })
end, { desc = "Explorer (cwd)" })
vim.keymap.set("n", "<leader>e", "<leader>fe", { remap = true, desc = "Explorer (root)" })
vim.keymap.set("n", "<leader>E", "<leader>fE", { remap = true, desc = "Explorer (cwd)" })
