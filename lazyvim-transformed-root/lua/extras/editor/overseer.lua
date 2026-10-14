-- Dependencies: Neovim 0.12.6; Git for vim.pack; overseer.nvim; executables required by chosen task definitions (make, npm, etc.) installed manually.
-- Docs: https://github.com/stevearc/overseer.nvim
-- Enable: require("extras.editor.overseer") in init.lua.
-- Tasks run ONLY on user invocation and can execute build scripts or change external files; review definitions first.
-- Optional DAP: require extras.dap.core first, then explicitly uncomment enable_dap below.
-- Optional Neotest: directly add consumers={overseer=require('neotest.consumers.overseer')} in extras/test/core.lua.
-- Optional Edgy: add {title='Overseer',ft='OverseerList',open=function()require('overseer').open()end} directly.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load task management with DAP integration disabled and opaque task/form windows.
vim.pack.add({ "https://github.com/stevearc/overseer.nvim" })
local overseer = require("overseer")
overseer.setup({
  dap = false,
  task_list = { keymaps = { ["<C-j>"] = false, ["<C-k>"] = false } },
  form = { win_opts = { winblend = 0 } },
  task_win = { win_opts = { winblend = 0 } },
})
-- overseer.enable_dap()
-- Show tasks, choose a task to run, or select an action for an existing task on user invocation.
vim.keymap.set("n", "<leader>ow", "<cmd>OverseerToggle!<cr>", { desc = "Task list" })
vim.keymap.set("n", "<leader>oo", "<cmd>OverseerRun<cr>", { desc = "Run task" })
vim.keymap.set("n", "<leader>ot", "<cmd>OverseerTaskAction<cr>", { desc = "Task action" })
