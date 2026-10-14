-- Dependencies: node; vscode-solidity-server (npm package vscode-solidity-server); forge (Foundry) for formatting.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): solidity.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Foundry: https://getfoundry.sh/
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable Solidity language support using the installed server definition.
vim.lsp.config("solidity_ls", {})
vim.lsp.enable({ "solidity_ls" })

-- Format Solidity with Foundry's forge fmt through Conform.
local conform = require("conform")
conform.formatters_by_ft["solidity"] = { "forge_fmt" }
