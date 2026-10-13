-- Dependencies: node; prisma-language-server (npm package @prisma/language-server).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): prisma.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("prismals", {})
vim.lsp.enable({ "prismals" })
