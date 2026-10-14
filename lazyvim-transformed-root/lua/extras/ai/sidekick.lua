-- Dependencies: Neovim 0.12.6; Git for vim.pack; sidekick.nvim; nvim-lspconfig; manually installed copilot-language-server + Copilot auth for NES; AI CLI tools installed/authenticated separately.
-- Docs: https://github.com/folke/sidekick.nvim
-- Enable: require("extras.ai.sidekick") in init.lua.
-- Load after plugins/lsp.lua and plugins/snacks.lua. Install Copilot server manually; authenticate with :LspCopilotSignIn.
-- CLI-only use: set nes.enabled=false and remove vim.lsp.enable('copilot') below. Install/authenticate each desired CLI (Claude, Codex, etc.) using that vendor's docs.
-- Optional lsof/ps for detecting sessions; tmux/zellij only if enabling cli.mux. No CLI installs or auth run here.
-- Conflicts: <leader>a keys overlap other chat extras; choose one chat mapping set. NES can share copilot-native; avoid copilot.lua duplicate clients.
-- Blink Tab integration: directly add function()return require('sidekick').nes_jump_or_apply()end before 'fallback' in plugins/blink.lua.
-- Optional Snacks picker sending: add sidekick.cli.picker.snacks.send action and Alt-a key directly in plugins/snacks.lua.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load Sidekick and the native Copilot server definition.
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig", "https://github.com/folke/sidekick.nvim" })
-- Enable next-edit suggestions only when the Copilot executable exists; CLI use remains available.
local have_server = vim.fn.executable("copilot-language-server") == 1
require("sidekick").setup({ nes = { enabled = have_server }, cli = { mux = { enabled = false }, picker = "snacks" } })
-- Share a native Copilot client for suggestions, or explain the CLI-only fallback.
if have_server then
  vim.lsp.config("copilot", { cmd = { "copilot-language-server", "--stdio" } })
  vim.lsp.enable("copilot")
else
  vim.notify("Sidekick CLI is enabled. Install copilot-language-server for next edit suggestions.", vim.log.levels.INFO)
end
local map, cli = vim.keymap.set, require("sidekick.cli")
-- Consume Tab when Sidekick jumps to or applies an edit; otherwise return the original key.
map("n", "<Tab>", function()
  return require("sidekick").nes_jump_or_apply() and "" or "<Tab>"
end, { expr = true, desc = "Jump/apply next edit suggestion" })
-- Focus, select, toggle, or detach installed AI CLI sessions.
map({ "n", "t", "i", "x" }, "<C-.>", function()
  cli.focus()
end, { desc = "Focus AI CLI" })
map("n", "<leader>aa", function()
  cli.toggle()
end, { desc = "Toggle AI CLI" })
map("n", "<leader>as", function()
  cli.select({ filter = { installed = true } })
end, { desc = "Select installed AI CLI" })
map("n", "<leader>ad", function()
  cli.close()
end, { desc = "Detach AI CLI" })
-- Send the current context, whole file, or visual selection using Sidekick prompt placeholders.
map({ "n", "x" }, "<leader>at", function()
  cli.send({ msg = "{this}" })
end, { desc = "Send this to AI CLI" })
map("n", "<leader>af", function()
  cli.send({ msg = "{file}" })
end, { desc = "Send file to AI CLI" })
map("x", "<leader>av", function()
  cli.send({ msg = "{selection}" })
end, { desc = "Send selection to AI CLI" })
map({ "n", "x" }, "<leader>ap", function()
  cli.prompt()
end, { desc = "Select AI prompt" })
-- Toggle next-edit suggestions independently of the AI CLI session.
map("n", "<leader>uN", function()
  require("sidekick.nes").toggle()
end, { desc = "Toggle next edit suggestions" })
