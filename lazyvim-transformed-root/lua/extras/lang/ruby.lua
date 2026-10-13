-- Dependencies: ruby; ruby-lsp, rubocop, erb-formatter (Ruby gems); optional solargraph or standard; optional rdbg (debug gem) for DAP.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Plugins: optional suketa/nvim-dap-ruby; https://github.com/suketa/nvim-dap-ruby
-- Parsers (install manually): ruby.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Ruby LSP: https://shopify.github.io/ruby-lsp/
-- Choose exactly one primary Ruby server; Ruby LSP + Solargraph duplicate navigation/completion.
-- RuboCop formatting is owned by Conform; disable ruby_lsp formatting if duplicated by your tool settings.
-- Optional tests: enable extras.test.core; add https://github.com/olimorris/neotest-rspec
-- to its vim.pack.add list and require("neotest-rspec") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.lsp.config("ruby_lsp", {})
vim.lsp.config("rubocop", {})
vim.lsp.enable({ "ruby_lsp", "rubocop" })
-- Alternative: replace ruby_lsp with solargraph and remove rubocop from enable().
-- Solargraph calls RuboCop itself; starting rubocop too duplicates diagnostics.
-- Alternative formatter: replace rubocop below with standardrb (gem standard).
local conform = require("conform")
conform.formatters_by_ft.ruby = { "rubocop" }
conform.formatters_by_ft.eruby = { "erb_format" }
if pcall(require, "dap") then
  vim.pack.add({ { src = "https://github.com/suketa/nvim-dap-ruby" } })
  require("dap-ruby").setup()
end
