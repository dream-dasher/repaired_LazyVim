-- Dependencies: taplo (Taplo CLI; https://taplo.tamasfe.dev/cli/installation.html).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): toml.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("taplo", {})
vim.lsp.enable({ "taplo" })
