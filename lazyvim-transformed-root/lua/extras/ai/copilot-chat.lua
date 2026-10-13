-- Dependencies: Neovim 0.12.6; Git for vim.pack; CopilotChat.nvim; plenary.nvim; curl >=8; Copilot Chat enabled in account; existing authenticated Copilot credentials.
-- Docs: https://copilotc-nvim.github.io/CopilotChat.nvim/
-- Enable: require("extras.ai.copilot-chat") in init.lua.
-- Enable/authenticate ai/copilot or ai/copilot-native first (:Copilot auth / :LspCopilotSignIn).
-- Optional accurate token counter: install tiktoken_core manually from https://github.com/gptlang/lua-tiktoken/releases into Lua's module path.
-- Conflicts: <leader>a keys overlap other chat frontends; edit these keys or choose one frontend.
-- For Blink slash commands: disable path provider when filetype=='copilot-chat' directly in plugins/blink.lua.
-- For Edgy: add {ft='copilot-chat',title='Copilot Chat',size={width=50}} directly to extras/ui/edgy.lua.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim", "https://github.com/CopilotC-Nvim/CopilotChat.nvim" })
local chat = require("CopilotChat")
chat.setup({
  auto_insert_mode = true,
  headers = { user = "  " .. (vim.env.USER or "User") .. " ", assistant = "  Copilot ", tool = "󰊳  Tool " },
  window = { width = 0.4 },
})
local map = vim.keymap.set
map({ "n", "x" }, "<leader>aa", function()
  chat.toggle()
end, { desc = "Toggle Copilot chat" })
map({ "n", "x" }, "<leader>ax", function()
  chat.reset()
end, { desc = "Clear Copilot chat" })
map({ "n", "x" }, "<leader>aq", function()
  vim.ui.input({ prompt = "Quick chat: " }, function(input)
    if input and input ~= "" then
      chat.ask(input)
    end
  end)
end, { desc = "Quick Copilot chat" })
map({ "n", "x" }, "<leader>ap", function()
  chat.select_prompt()
end, { desc = "Copilot prompt actions" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "copilot-chat",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    map("i", "<C-s>", "<CR>", { buffer = event.buf, remap = true, desc = "Submit chat prompt" })
  end,
})
