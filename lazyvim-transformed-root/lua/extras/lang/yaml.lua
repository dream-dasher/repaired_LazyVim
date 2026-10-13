-- Dependencies: node; yaml-language-server (npm yaml-language-server).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: b0o/SchemaStore.nvim; https://github.com/b0o/SchemaStore.nvim
-- Parsers (install manually): yaml.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({ { src = "https://github.com/b0o/SchemaStore.nvim" } })
vim.lsp.config("yamlls", {
  capabilities = {
    textDocument = { foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    } },
  },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = { enable = true },
      validate = true,
      schemas = require("schemastore").yaml.schemas(),
      schemaStore = { enable = false, url = "" },
    },
  },
})
vim.lsp.enable("yamlls")
