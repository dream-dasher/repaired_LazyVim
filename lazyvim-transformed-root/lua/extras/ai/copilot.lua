-- Dependencies: Neovim 0.12.6; Git for vim.pack; copilot.lua; Copilot subscription/auth; manually installed copilot-language-server executable (or an absolute custom binary path).
-- Docs: https://github.com/zbirenbaum/copilot.lua
-- Enable: require("extras.ai.copilot") in init.lua.
-- Install the official server manually: https://github.com/github/copilot-language-server-release (npm package @github/copilot-language-server requires Node).
-- Authenticate explicitly with :Copilot auth after setup. custom_server_filepath disables the plugin's automatic server download.
-- Conflicts: mutually exclusive with copilot-native; choose one inline AI provider (Codeium, Supermaven, native Copilot, copilot.lua).
-- Uses Alt-l to accept so Blink's Tab/snippet mappings remain explicit. For Blink menu integration, manually add blink-copilot URL/provider in plugins/blink.lua and disable suggestion.enabled here.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })
local server = vim.fn.exepath("copilot-language-server")
if server == "" then
  vim.notify(
    "Install copilot-language-server on PATH, or edit extras/ai/copilot.lua with its absolute path.",
    vim.log.levels.WARN
  )
  return
end
-- Prevent a second Copilot client from the native LSP definition.
vim.lsp.enable("copilot", false)
require("copilot").setup({
  server = { type = "binary", custom_server_filepath = server },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = { accept = "<M-l>", next = "<M-]>", prev = "<M-[>", dismiss = "<C-]>" },
  },
  panel = { enabled = false },
  filetypes = { markdown = true, help = true },
})
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
-- Optional direct edit in plugins/blink.lua:
-- vim.pack.add({ "https://github.com/fang2hou/blink-copilot" })
-- sources.default = { "lsp", "path", "snippets", "buffer", "copilot" }
-- sources.providers.copilot = { name = "Copilot", module = "blink-copilot", score_offset = 100, async = true }
