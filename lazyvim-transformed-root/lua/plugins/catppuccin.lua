-- External dependencies: none. Plugin dependencies: catppuccin/nvim.
-- Manual builds: none. Docs: https://github.com/catppuccin/nvim#configuration
-- Catppuccin writes its compiled palette cache under stdpath('cache').
-- Optional alternative to plugins.colorscheme: enable only one colorscheme call.
-- Keep this before plugins.ui so Bufferline can use the Catppuccin palette.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Install the alternative theme under its expected module name.
vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })
-- Enable highlights for the configured plugins and underline LSP diagnostics.
require("catppuccin").setup({
  auto_integrations = false,
  lsp_styles = {
    underlines = {
      errors = { "undercurl" },
      hints = { "undercurl" },
      warnings = { "undercurl" },
      information = { "undercurl" },
    },
  },
  integrations = {
    blink_cmp = true,
    flash = true,
    grug_far = true,
    gitsigns = true,
    lsp_trouble = true,
    mini = true,
    noice = true,
    snacks = true,
    which_key = true,
  },
})
-- Apply the dark Mocha palette after configuring its integrations.
vim.cmd.colorscheme("catppuccin-mocha")
