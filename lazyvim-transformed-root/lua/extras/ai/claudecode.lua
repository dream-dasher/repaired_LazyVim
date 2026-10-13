-- Dependencies: Neovim 0.12.6; Git for vim.pack; claudecode.nvim; Claude Code CLI (`claude`) installed manually and authenticated; default Snacks terminal.
-- Docs: https://github.com/coder/claudecode.nvim
-- Enable: require("extras.ai.claudecode") in init.lua.
-- Install/authenticate Claude Code using https://code.claude.com/docs/en/setup before enabling.
-- Conflicts: <leader>a maps overlap Avante/CopilotChat/Sidekick; choose a chat frontend or edit these keys.
-- Plugin buffers/diff operations are user invoked; this config never installs or starts authentication.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/coder/claudecode.nvim" })
require("claudecode").setup({})
local map = vim.keymap.set
for key, command in pairs({
  ac = "ClaudeCode",
  af = "ClaudeCodeFocus",
  ar = "ClaudeCode --resume",
  aC = "ClaudeCode --continue",
  ab = "ClaudeCodeAdd %",
  aa = "ClaudeCodeDiffAccept",
  ad = "ClaudeCodeDiffDeny",
}) do
  map("n", "<leader>" .. key, "<cmd>" .. command .. "<cr>", { desc = command })
end
map("x", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "NvimTree", "neo-tree", "oil" },
  callback = function(event)
    map("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { buffer = event.buf, desc = "Add file to Claude" })
  end,
})
