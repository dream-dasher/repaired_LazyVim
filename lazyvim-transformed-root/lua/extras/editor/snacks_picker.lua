-- Dependencies: Neovim 0.12.6; Git for vim.pack; Snacks (already installed/configured in plugins/snacks.lua); rg and fd for searching.
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
-- Enable: require("extras.editor.snacks_picker") in init.lua.
-- Already enabled by default; keep require('plugins.snacks') and core keymaps. No second setup call is needed.
-- Conflicts: Telescope or fzf-lua replace the same search/LSP keys; choose one default picker.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Direct alias: the defaults are already configured once by this ordinary module.
require("plugins.snacks")
