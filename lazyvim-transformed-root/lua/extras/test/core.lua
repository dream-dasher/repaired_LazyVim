-- Dependencies: Neovim 0.12.6; Git for vim.pack; neotest; nvim-nio; plenary.nvim; nvim-treesitter; default Trouble; per-language adapters and test runners installed manually.
-- Docs: https://github.com/nvim-neotest/neotest
-- Enable: require("extras.test.core") in init.lua.
-- Load AFTER plugins/treesitter.lua and BEFORE language extras. Edit this file's vim.pack list and adapters directly.
-- Example: add 'https://github.com/nvim-neotest/neotest-python' to vim.pack.add, then require('neotest-python')({python='python3'}) below.
-- Tests execute project code and can have external side effects; this config only sets up commands and mappings.
-- Optional DAP: enable extras.dap.core first for <leader>td. No adapter registry or runtime setup merging.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load test orchestration and its Lua dependencies; adapters must be added explicitly.
vim.pack.add({
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-neotest/neotest",
  -- Add adapter plugin URLs here, for example:
  -- "https://github.com/nvim-neotest/neotest-python",
})
local neotest = require("neotest")
-- Configure test status/output and keep the adapter list editable in this file.
neotest.setup({
  adapters = {
    -- require("neotest-python")({ python = "python3" }),
  },
  status = { virtual_text = true },
  output = { open_on_run = true },
  quickfix = {
    -- Show test quickfix results through Trouble without taking focus from the current window.
    open = function()
      require("trouble").open({ mode = "quickfix", focus = false })
    end,
  },
})
-- Keep test diagnostic messages on one line in Neotest's namespace, preserving other diagnostics.
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      return diagnostic.message:gsub("%s+", " "):gsub("^%s+", "")
    end,
  },
}, vim.api.nvim_create_namespace("neotest"))
-- Run/attach to file, project, nearest, or previous tests only when a test key is invoked.
local map = vim.keymap.set
map("n", "<leader>ta", function()
  neotest.run.attach()
end, { desc = "Attach to test" })
map("n", "<leader>tt", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "Test file" })
map("n", "<leader>tT", function()
  neotest.run.run(vim.uv.cwd())
end, { desc = "Test project" })
map("n", "<leader>tr", function()
  neotest.run.run()
end, { desc = "Test nearest" })
map("n", "<leader>tl", function()
  neotest.run.run_last()
end, { desc = "Test last" })
-- Inspect test summaries/output, stop runs, or toggle watching for the current file.
map("n", "<leader>ts", function()
  neotest.summary.toggle()
end, { desc = "Test summary" })
map("n", "<leader>to", function()
  neotest.output.open({ enter = true, auto_close = true })
end, { desc = "Test output" })
map("n", "<leader>tO", function()
  neotest.output_panel.toggle()
end, { desc = "Test output panel" })
map("n", "<leader>tS", function()
  neotest.run.stop()
end, { desc = "Stop test" })
map("n", "<leader>tw", function()
  neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "Watch test file" })
-- Run the nearest test through its adapter's DAP strategy instead of the normal runner.
map("n", "<leader>td", function()
  neotest.run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })
