-- Dependencies: python3; pyright-langserver (npm pyright, needs node); ruff (pip/uv ruff); fd for venv discovery; optional debugpy-adapter (pip debugpy).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Plugins: linux-cultist/venv-selector.nvim; optional mfussenegger/nvim-dap-python; https://github.com/linux-cultist/venv-selector.nvim
-- Parsers (install manually): python, ninja, rst.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Enable extras.formatting.black AFTER this module to replace Ruff formatting with Black.
-- Ruff still supplies lint fixes/code actions; avoid enabling a second Ruff lint client.
-- venv-selector changes only Neovim process environment; PEP-723 workflows can create uv environments when requested.
-- Optional tests: enable extras.test.core; add https://github.com/nvim-neotest/neotest-python
-- to its vim.pack.add list and require("neotest-python") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.lsp.config("pyright", {})
vim.lsp.config("ruff", {
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = { settings = { logLevel = "error" } },
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})
vim.lsp.enable({ "pyright", "ruff" })
-- Alternative: replace pyright with basedpyright (pip basedpyright; basedpyright-langserver).
-- Use either pyright or basedpyright; use the native Ruff server rather than deprecated ruff-lsp.
vim.pack.add({ { src = "https://github.com/linux-cultist/venv-selector.nvim" } })
require("venv-selector").setup({ options = {
  notify_user_on_venv_activation = true,
  override_notify = false,
} })
require("conform").formatters_by_ft.python = { "ruff_fix", "ruff_format" }
local group = vim.api.nvim_create_augroup("PythonMappings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "python",
  callback = function(event)
    vim.keymap.set("n", "<leader>cv", "<cmd>VenvSelect<cr>", { buffer = event.buf, desc = "Select VirtualEnv" })
  end,
})
if pcall(require, "dap") then
  vim.pack.add({ { src = "https://github.com/mfussenegger/nvim-dap-python" } })
  require("dap-python").setup("debugpy-adapter")
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
