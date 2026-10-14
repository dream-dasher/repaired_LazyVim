-- Dependencies: dart (Dart SDK; https://dart.dev/get-dart).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): dart.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Optional tests: enable extras.test.core; add https://github.com/sidlatau/neotest-dart
-- to its vim.pack.add list and require("neotest-dart") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable the Dart SDK language server for Dart buffers.
vim.lsp.config("dartls", {})
vim.lsp.enable({ "dartls" })

-- Format Dart through the SDK command configured by Conform.
local conform = require("conform")
conform.formatters_by_ft["dart"] = { "dart_format" }
