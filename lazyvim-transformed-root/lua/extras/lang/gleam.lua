-- Dependencies: gleam (Gleam toolchain; https://gleam.run/getting-started/installing/).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): gleam.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("gleam", {})
vim.lsp.enable({ "gleam" })

local conform = require("conform")
conform.formatters_by_ft["gleam"] = { "gleam" }
