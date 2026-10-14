-- Dependencies: Neovim 0.12.6; Git for vim.pack; supermaven-nvim; manually installed sm-agent binary; Supermaven auth/account.
-- Docs: https://github.com/supermaven-inc/supermaven-nvim
-- Enable: require("extras.ai.supermaven") in init.lua.
-- Manually download platform sm-agent using the vendor download endpoint documented in binary_fetcher.lua, place at the plugin's cache path, mark executable.
-- This module checks that exact cache path BEFORE setup, preventing the plugin's automatic binary downloader.
-- The cache path is from upstream binary_fetcher:local_binary_path(); if upstream changes it, this guard must be reviewed.
-- Authenticate explicitly with :SupermavenUseFree or :SupermavenUsePro. Conflicts: choose one inline AI provider.
-- Blink menu option: install blink.compat and add provider module='blink.compat.source', name='supermaven'; set disable_inline_completion=true here.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Make Supermaven available; its agent must already exist before setup.
vim.pack.add({ "https://github.com/supermaven-inc/supermaven-nvim" })
-- Check the upstream agent cache path and stop before its automatic downloader can run.
local fetcher = require("supermaven-nvim.binary.binary_fetcher")
local binary = fetcher:local_binary_path()
if vim.fn.executable(binary) == 0 then
  vim.notify(
    "Manually install Supermaven sm-agent at " .. binary .. " before enabling this extra.",
    vim.log.levels.WARN
  )
  return
end
-- Configure inline acceptance and exclude large files and Snacks UI buffers.
require("supermaven-nvim").setup({
  keymaps = { accept_suggestion = "<M-l>", clear_suggestion = "<C-]>", accept_word = "<M-j>" },
  disable_inline_completion = false,
  ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
})
