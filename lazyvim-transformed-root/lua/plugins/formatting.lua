-- Dependencies: git for vim.pack; stylua (Lua), shfmt (shell), fish/fish_indent (Fish).
-- Plugins: stevearc/conform.nvim. Install external formatter commands yourself, on PATH.
-- Docs: https://github.com/stevearc/conform.nvim#setup
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Make the formatter coordinator available; formatter executables remain external.
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

-- Prefer the listed filetype formatters and fall back to LSP formatting when needed.
require("conform").setup({
  default_format_opts = { timeout_ms = 3000, async = false, lsp_format = "fallback" },
  formatters_by_ft = {
    lua = { "stylua" },
    fish = { "fish_indent" },
    sh = { "shfmt" },
  },
  formatters = { injected = { options = { ignore_errors = true } } },
  -- Before saving, format ordinary file buffers only when their autoformat setting permits it.
  format_on_save = function(buf)
    if vim.bo[buf].buftype ~= "" or not require("util.format").enabled(buf) then
      return
    end
    return { timeout_ms = 3000, lsp_format = "fallback" }
  end,
})

-- Format embedded languages, such as code inside a Markdown fence, on explicit request.
vim.keymap.set({ "n", "x" }, "<leader>cF", function()
  require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end, { desc = "Format Injected Languages" })
