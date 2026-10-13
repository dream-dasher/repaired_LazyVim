-- Dependencies: node; vscode-json-language-server (npm vscode-langservers-extracted).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: b0o/SchemaStore.nvim; https://github.com/b0o/SchemaStore.nvim
-- Parsers (install manually): json, jsonc, json5.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({ { src = "https://github.com/b0o/SchemaStore.nvim" } })
vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      format = { enable = true },
      validate = { enable = true },
    },
  },
})
vim.lsp.enable("jsonls")
