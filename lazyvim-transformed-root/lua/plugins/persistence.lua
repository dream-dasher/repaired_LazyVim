-- External dependencies: none (Git optionally supplies branch-specific sessions).
-- Plugin dependencies: folke/persistence.nvim. Manual builds: none.
-- Docs: https://github.com/folke/persistence.nvim#usage
-- Saves session files under stdpath('state')/sessions on exit; it never restores
-- automatically. Stop saving the current session with <leader>qd.
-- Setup creates that sessions directory. Git is queried only when naming a session.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Enable saving sessions on exit; restoration remains an explicit user action.
vim.pack.add({ { src = "https://github.com/folke/persistence.nvim" } })
local persistence = require("persistence")
persistence.setup({})
-- Restore this directory's session, choose another, restore the latest, or stop saving.
vim.keymap.set("n", "<leader>qs", function()
  persistence.load()
end, { desc = "Restore Session" })
vim.keymap.set("n", "<leader>qS", persistence.select, { desc = "Select Session" })
vim.keymap.set("n", "<leader>ql", function()
  persistence.load({ last = true })
end, { desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qd", persistence.stop, { desc = "Don't Save Current Session" })
