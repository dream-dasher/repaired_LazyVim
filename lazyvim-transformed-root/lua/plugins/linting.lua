-- Dependencies: git for vim.pack; fish for the default Fish linter.
-- Plugins: mfussenegger/nvim-lint; enabled language modules list their additional tools.
-- Docs: https://github.com/mfussenegger/nvim-lint#usage
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Configure the default Fish linter; language extras add their own filetype tools.
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })
local lint = require("lint")
lint.linters_by_ft = { fish = { "fish" } }

-- Track each buffer's latest request so rapid events share one delayed lint run.
local pending = {}
-- Wait 100 ms after the latest read/save/InsertLeave event before linting its buffer.
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("config_lint", { clear = true }),
  callback = function(event)
    local buf = event.buf
    pending[buf] = (pending[buf] or 0) + 1
    local generation = pending[buf]
    -- Discard superseded requests, deleted buffers and buffers that are not ordinary files.
    vim.defer_fn(function()
      if generation ~= pending[buf] or not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
        return
      end
      -- Run in the requested buffer so nvim-lint uses its filetype and filename.
      vim.api.nvim_buf_call(buf, function()
        lint.try_lint()
      end)
    end, 100)
  end,
})
-- Forget a wiped buffer's request counter and invalidate its pending lint callback.
vim.api.nvim_create_autocmd("BufWipeout", {
  group = "config_lint",
  callback = function(event)
    pending[event.buf] = nil
  end,
})
