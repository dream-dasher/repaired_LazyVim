-- Dependencies: python3; ty and ruff installed globally on PATH; fd for venv discovery; optional debugpy-adapter (pip debugpy).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Plugins: linux-cultist/venv-selector.nvim; optional mfussenegger/nvim-dap-python; https://github.com/linux-cultist/venv-selector.nvim
-- Parsers (install manually): python, ninja, rst.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Python servers: https://docs.astral.sh/ty/editors/ and https://docs.astral.sh/ruff/editors/setup/
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Enable extras.formatting.black AFTER this module to replace Ruff formatting with Black.
-- Ruff still supplies lint fixes/code actions; avoid enabling a second Ruff lint client.
-- venv-selector changes only Neovim process environment; PEP-723 workflows can create uv environments when requested.
-- Optional tests: enable extras.test.core; add https://github.com/nvim-neotest/neotest-python
-- to its vim.pack.add list and require("neotest-python") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Pair ty navigation/type analysis with Ruff lint fixes and code actions.
-- Invoke the global PATH executables directly; no uv run or project-local wrapper.
vim.lsp.config("ty", { cmd = { "ty", "server" } })
vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = { settings = { logLevel = "error" } },
  -- Let ty answer hover requests to avoid competing Ruff responses.
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})
vim.lsp.enable({ "ty", "ruff" })
-- Alternatives: replace ty's config and enable entry with pyright or basedpyright.
-- Keep one type-checking/navigation server and native Ruff, rather than deprecated ruff-lsp.
-- Load virtual-environment selection with activation notifications enabled.
vim.pack.add({ { src = "https://github.com/linux-cultist/venv-selector.nvim" } })
require("venv-selector").setup({ options = {
  notify_user_on_venv_activation = true,
  override_notify = false,
} })
-- Apply Ruff fixes before Ruff formatting through Conform.
require("conform").formatters_by_ft.python = { "ruff_fix", "ruff_format" }
local group = vim.api.nvim_create_augroup("PythonMappings", { clear = true })
-- Add virtual-environment selection only to buffers detected as Python.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "python",
  callback = function(event)
    vim.keymap.set("n", "<leader>cv", "<cmd>VenvSelect<cr>", { buffer = event.buf, desc = "Select VirtualEnv" })
  end,
})
-- Add debugpy integration only when the optional DAP module is available.
if pcall(require, "dap") then
  vim.pack.add({ { src = "https://github.com/mfussenegger/nvim-dap-python" } })
  require("dap-python").setup("debugpy-adapter")
  -- On Python filetype detection, add mappings to debug a test method or class.
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = function(event)
      vim.keymap.set(
        "n",
        "<leader>dPt",
        require("dap-python").test_method,
        { buffer = event.buf, desc = "Debug Method" }
      )
      vim.keymap.set("n", "<leader>dPc", require("dap-python").test_class, { buffer = event.buf, desc = "Debug Class" })
    end,
  })
end
