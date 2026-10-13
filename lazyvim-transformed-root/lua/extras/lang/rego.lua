-- Dependencies: regols (Rego language server) and regal (Regal CLI; https://github.com/open-policy-agent/regal).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): rego.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Both servers are preserved; if diagnostics overlap, remove regols or regal from enable().
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("regols", {})
vim.lsp.config("regal", {})
vim.lsp.enable({ "regols", "regal" })
