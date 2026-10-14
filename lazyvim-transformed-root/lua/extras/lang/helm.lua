-- Dependencies: helm_ls (helm-ls release; https://github.com/mrjosh/helm-ls); yaml-language-server (npm yaml-language-server); helm for CLI commands.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: qvalentin/helm-ls.nvim; https://github.com/qvalentin/helm-ls.nvim
-- Parsers (install manually): helm.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- helm-ls.nvim supplies filetype detection and template helpers; native LSP starts helm_ls once.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Load Helm filetype/template helpers, then enable the native Helm server.
vim.pack.add({ { src = "https://github.com/qvalentin/helm-ls.nvim" } })
require("helm-ls").setup({})
vim.lsp.config("helm_ls", {})
vim.lsp.enable("helm_ls")
