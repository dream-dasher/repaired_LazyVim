-- Dependencies: node; elm, elm-test, elm-format, elm-language-server (npm packages elm, elm-test, elm-format, @elm-tooling/elm-language-server).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): elm.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable the Elm language server for navigation, diagnostics, and completion.
vim.lsp.config("elmls", {})
vim.lsp.enable({ "elmls" })

-- Use elm-format through the core formatting hooks.
local conform = require("conform")
conform.formatters_by_ft["elm"] = { "elm_format" }
