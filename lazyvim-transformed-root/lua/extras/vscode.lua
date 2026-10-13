-- Dependencies: Neovim 0.12.6; Git for vim.pack; VS Code with vscode-neovim extension and its supplied `vscode` Lua module; no plugin dependency added here.
-- Docs: https://github.com/vscode-neovim/vscode-neovim
-- Enable: require("extras.vscode") in init.lua.
-- This adapts keys only; it does not unload terminal UI/LSP plugins already set up.
-- Use an explicit early block at the TOP of init.lua, before the terminal defaults (a separate VS Code config is also fine):
-- if vim.g.vscode then require('config.options'); require('extras.coding.mini-surround'); require('extras.vscode'); return end
-- Add only desired editing modules in that block, e.g. extras.editor.dial/mini-move; use VS Code's own UI, LSP, and completion.
-- Dropped: plugin allow-list, manager monkey patches, framework event hooks, and runtime spec conditions.
-- If used after core keymaps instead, move this call last so VS Code's actions replace terminal mappings.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

if not vim.g.vscode then
  return
end
local vscode = require("vscode")
local map = vim.keymap.set
map("n", "<leader><space>", function()
  vscode.call("workbench.action.quickOpen")
end, { desc = "Find file" })
map("n", "<leader>/", function()
  vscode.call("workbench.action.findInFiles")
end, { desc = "Find in files" })
map("n", "<leader>ss", function()
  vscode.call("workbench.action.gotoSymbol")
end, { desc = "Symbols" })
for _, key in ipairs({ "<leader>ft", "<leader>fT", "<C-/>" }) do
  map("n", key, function()
    vscode.call("workbench.action.terminal.toggleTerminal")
  end, { desc = "Toggle VS Code terminal" })
end
map("n", "<S-h>", function()
  vscode.call("workbench.action.previousEditor")
end, { desc = "Previous editor" })
map("n", "<S-l>", function()
  vscode.call("workbench.action.nextEditor")
end, { desc = "Next editor" })
