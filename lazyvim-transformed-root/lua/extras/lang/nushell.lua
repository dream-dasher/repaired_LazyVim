-- Dependencies: nu (Nushell; https://www.nushell.sh/book/installation.html).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): nu.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable the language server bundled with Nushell for nu buffers.
vim.lsp.config("nushell", {})
vim.lsp.enable({ "nushell" })
