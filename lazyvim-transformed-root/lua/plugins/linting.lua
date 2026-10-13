-- Dependencies: git for vim.pack; fish for the default Fish linter.
-- Plugins: mfussenegger/nvim-lint; enabled language modules list their additional tools.
-- Docs: https://github.com/mfussenegger/nvim-lint#usage
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })
local lint = require("lint")
lint.linters_by_ft = { fish = { "fish" } }

local pending = {}
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("config_lint", { clear = true }),
  callback = function(event)
    local buf = event.buf
    pending[buf] = (pending[buf] or 0) + 1
    local generation = pending[buf]
    vim.defer_fn(function()
      if generation ~= pending[buf] or not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
        return
      end
      vim.api.nvim_buf_call(buf, function()
        lint.try_lint()
      end)
    end, 100)
  end,
})
vim.api.nvim_create_autocmd("BufWipeout", {
  group = "config_lint",
  callback = function(event)
    pending[event.buf] = nil
  end,
})
