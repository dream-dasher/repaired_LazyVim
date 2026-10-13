-- Dependencies: node; ember-language-server (npm @ember-tooling/ember-language-server); prettier (npm prettier) if formatting is enabled.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): css, glimmer, glimmer_javascript, glimmer_typescript.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Enable extras.lang.typescript first if you want JavaScript/TypeScript LSP support.
-- For Prettier formatting enable extras.formatting.prettier and the assignment below.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("ember", {})
vim.lsp.enable("ember")
vim.filetype.add({ extension = { gjs = "javascript.glimmer", gts = "typescript.glimmer" } })
-- Uncomment if Prettier owns formatting in this project:
-- require("conform").formatters_by_ft.glimmer = { "prettier" }
