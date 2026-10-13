-- Dependencies: node; docker-langserver (npm package dockerfile-language-server-nodejs); docker-compose-langserver (npm package @microsoft/compose-language-service); hadolint (hadolint release).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.linting (nvim-lint).
-- Parsers (install manually): dockerfile.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Lint tool: https://github.com/hadolint/hadolint ; Docker daemon is not needed for LSP/lint.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("dockerls", {})
vim.lsp.config("docker_compose_language_service", {})
vim.lsp.enable({ "dockerls", "docker_compose_language_service" })

local lint = require("lint")
lint.linters_by_ft["dockerfile"] = { "hadolint" }
