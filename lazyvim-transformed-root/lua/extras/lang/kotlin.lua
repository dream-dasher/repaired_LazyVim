-- Dependencies: java (JDK); kotlin-language-server (fwcd release); ktlint (release); optional kotlin-debug-adapter (fwcd release).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Parsers (install manually): kotlin.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Tools: https://github.com/fwcd/kotlin-language-server ; https://github.com/fwcd/kotlin-debug-adapter
-- https://pinterest.github.io/ktlint/latest/install/
-- Build the project explicitly before launch; this module does not run Gradle.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("kotlin_language_server", {})
vim.lsp.enable("kotlin_language_server")
require("conform").formatters_by_ft.kotlin = { "ktlint" }
require("lint").linters_by_ft.kotlin = { "ktlint" }
local ok, dap = pcall(require, "dap")
if ok then
  dap.adapters.kotlin =
    { type = "executable", command = "kotlin-debug-adapter", options = { auto_continue_if_many_stopped = false } }
  dap.configurations.kotlin = {
    {
      type = "kotlin",
      request = "launch",
      name = "This file",
      projectRoot = "${workspaceFolder}",
      mainClass = function()
        local file = vim.api.nvim_buf_get_name(0)
        local relative = file:match("/src/main/kotlin/(.+)%.kt$")
        return relative and (relative:gsub("/", ".") .. "Kt") or vim.fn.input("Main class: ")
      end,
      jsonLogFile = "",
      enableJsonLogging = false,
    },
    {
      type = "kotlin",
      request = "attach",
      name = "Attach to debugging session",
      port = 5005,
      args = {},
      projectRoot = vim.fn.getcwd,
      hostName = "localhost",
      timeout = 2000,
    },
  }
end
