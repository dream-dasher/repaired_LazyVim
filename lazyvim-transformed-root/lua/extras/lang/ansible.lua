-- Dependencies: node; ansible-language-server (npm @ansible/ansible-language-server); Python; ansible-playbook (pip ansible-core); ansible-lint (pip ansible-lint).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: mfussenegger/nvim-ansible (https://github.com/mfussenegger/nvim-ansible).
-- Parsers (install manually): yaml.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({ { src = "https://github.com/mfussenegger/nvim-ansible" } })
vim.lsp.config("ansiblels", {})
vim.lsp.enable("ansiblels")
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("AnsibleMappings", { clear = true }),
  pattern = "yaml.ansible",
  callback = function(event)
    vim.keymap.set("n", "<leader>ta", function()
      require("ansible").run()
    end, { buffer = event.buf, desc = "Ansible Run Playbook/Role", silent = true })
  end,
})
