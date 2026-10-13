-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-lspconfig; manually installed copilot-language-server on PATH; Copilot account/auth; native inline completion.
-- Docs: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/copilot.lua
-- Enable: require("extras.ai.copilot-native") in init.lua.
-- Load AFTER plugins/lsp.lua. Manually install the official server from https://github.com/github/copilot-language-server-release.
-- Authenticate explicitly with :LspCopilotSignIn. Node is needed for the npm server distribution.
-- Conflicts: mutually exclusive with ai/copilot.lua and other inline AI providers. Sidekick can share this native LSP client.
-- Uses Alt-l accept; to use Tab directly edit plugins/blink.lua keymap with function() return vim.lsp.inline_completion.get() end before fallback.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
if vim.fn.executable("copilot-language-server") == 0 then
  vim.notify("Install copilot-language-server on PATH before enabling native Copilot.", vim.log.levels.WARN)
  return
end
vim.lsp.config("copilot", { cmd = { "copilot-language-server", "--stdio" } })
vim.lsp.enable("copilot")
vim.lsp.inline_completion.enable()
vim.keymap.set("i", "<M-l>", function()
  return vim.lsp.inline_completion.get() and "" or "<M-l>"
end, { expr = true, desc = "Accept inline suggestion" })
vim.keymap.set({ "i", "n" }, "<M-]>", function()
  vim.lsp.inline_completion.select({ count = 1 })
end, { desc = "Next inline suggestion" })
vim.keymap.set({ "i", "n" }, "<M-[>", function()
  vim.lsp.inline_completion.select({ count = -1 })
end, { desc = "Previous inline suggestion" })
