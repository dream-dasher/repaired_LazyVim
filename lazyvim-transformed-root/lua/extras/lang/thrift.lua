-- Dependencies: thriftls (binary from joyme123/thrift-ls releases; https://github.com/joyme123/thrift-ls/releases).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): thrift.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable Thrift schema language support through the native server definition.
vim.lsp.config("thriftls", {})
vim.lsp.enable({ "thriftls" })
