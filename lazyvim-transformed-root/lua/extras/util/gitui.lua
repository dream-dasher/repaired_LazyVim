-- Dependencies: Neovim 0.12.6; Git for vim.pack; GitUI (`gitui`) and Git executables installed manually; default Snacks terminal.
-- Docs: https://github.com/gitui-org/gitui
-- Enable: require("extras.util.gitui") in init.lua.
-- Load AFTER config/keymaps.lua; replaces <leader>gg/gG terminal commands for GitUI.
-- Conflicts: these are the default Lazygit keys; comment/remove their keymap lines directly in config/keymaps.lua if preferred.
-- GitUI's actions can modify the repository; this module only opens it on explicit invocation.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Launch GitUI in a Snacks terminal at project root or the current working directory.
vim.keymap.set("n", "<leader>gg", function()
  Snacks.terminal({ "gitui" }, { cwd = require("util.root").get() })
end, { desc = "GitUI (root)" })
vim.keymap.set("n", "<leader>gG", function()
  Snacks.terminal({ "gitui" }, { cwd = vim.uv.cwd() })
end, { desc = "GitUI (cwd)" })
-- GitUI has no direct equivalent to Lazygit's file-history view.
pcall(vim.keymap.del, "n", "<leader>gf")
pcall(vim.keymap.del, "n", "<leader>gl")
