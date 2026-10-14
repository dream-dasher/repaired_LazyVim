-- Dependencies: terraform (HashiCorp CLI); terraform-ls (HashiCorp language server); packer for HCL formatting.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Parsers (install manually): terraform, hcl.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Tools: https://github.com/hashicorp/terraform-ls
-- terraform validate runs against the project and may require a manually initialized working directory.
-- Terraform Telescope extensions are optional; install ANGkeith/telescope-terraform-doc.nvim and
-- cappyzawa/telescope-terraform.nvim and call telescope.load_extension("terraform_doc" / "terraform") directly.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Enable Terraform language support using its native server definition.
vim.lsp.config("terraformls", {})
vim.lsp.enable({ "terraformls" })

-- Use Packer for generic HCL and Terraform's formatter for Terraform variants.
local conform = require("conform")
conform.formatters_by_ft["hcl"] = { "packer_fmt" }
conform.formatters_by_ft["terraform"] = { "terraform_fmt" }
conform.formatters_by_ft["tf"] = { "terraform_fmt" }
conform.formatters_by_ft["terraform-vars"] = { "terraform_fmt" }

-- Run Terraform validation through the existing lint events for Terraform files.
local lint = require("lint")
lint.linters_by_ft["terraform"] = { "terraform_validate" }
lint.linters_by_ft["tf"] = { "terraform_validate" }
