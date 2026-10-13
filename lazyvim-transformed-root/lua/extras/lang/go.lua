-- Dependencies: go; gopls, goimports, gofumpt (Go packages); golangci-lint (release); optional dlv (Delve) for debugging.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Plugins: optional leoluz/nvim-dap-go; https://github.com/leoluz/nvim-dap-go
-- Parsers (install manually): go, gomod, gowork, gosum.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Tool installs (manual): go install golang.org/x/tools/gopls@latest
-- go install golang.org/x/tools/cmd/goimports@latest ; go install mvdan.cc/gofumpt@latest
-- go install github.com/go-delve/delve/cmd/dlv@latest ; https://golangci-lint.run/welcome/install/
-- gopls can run project build scripts, generate code, and modify dependencies when its code lenses are invoked.
-- The old fabricated semanticTokensProvider workaround is omitted; current gopls advertises its capabilities.
-- Optional tests: enable extras.test.core; add https://github.com/fredrikaverpil/neotest-golang
-- to its vim.pack.add list and require("neotest-golang")({ dap_go_enabled = true }) to its adapters table.
-- Optional Go code actions: install gomodifytags/impl on PATH, enable extras.lsp.none-ls,
-- and add these entries to that module's sources table directly:
-- require("null-ls").builtins.code_actions.gomodifytags,
-- require("null-ls").builtins.code_actions.impl,
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.lsp.config("gopls", {
  init_options = { semanticTokens = true },
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = { nilness = true, unusedparams = true, unusedwrite = true, useany = true },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
    },
  },
})
vim.lsp.enable("gopls")
require("conform").formatters_by_ft.go = { "goimports", "gofumpt" }
require("lint").linters_by_ft.go = { "golangcilint" }
if pcall(require, "dap") then
  vim.pack.add({ { src = "https://github.com/leoluz/nvim-dap-go" } })
  require("dap-go").setup({})
end
