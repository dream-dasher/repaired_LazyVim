-- Dependencies: Neovim 0.12.6; Git for vim.pack; vim-illuminate; optional LSP/Tree-sitter parsers.
-- Docs: https://github.com/RRethy/vim-illuminate
-- Enable: require("extras.editor.illuminate") in init.lua.
-- Set words.enabled=false directly in plugins/snacks.lua before enabling this alternative.
-- Load after config/keymaps.lua. Conflicts: replaces [[/]] reference navigation and <leader>ux toggle.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/RRethy/vim-illuminate" })
local illuminate = require("illuminate")
illuminate.configure({ delay = 200, large_file_cutoff = 2000, large_file_overrides = { providers = { "lsp" } } })
local function maps(buffer)
  vim.keymap.set("n", "]]", function()
    illuminate.goto_next_reference(false)
  end, { buffer = buffer, desc = "Next reference" })
  vim.keymap.set("n", "[[", function()
    illuminate.goto_prev_reference(false)
  end, { buffer = buffer, desc = "Previous reference" })
  vim.keymap.set("n", "<A-n>", function()
    illuminate.goto_next_reference(false)
  end, { buffer = buffer, desc = "Next reference" })
  vim.keymap.set("n", "<A-p>", function()
    illuminate.goto_prev_reference(false)
  end, { buffer = buffer, desc = "Previous reference" })
end
maps()
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config_illuminate", { clear = true }),
  callback = function(event)
    maps(event.buf)
  end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "config_illuminate",
  callback = function(event)
    maps(event.buf)
  end,
})
for _, client in ipairs(vim.lsp.get_clients()) do
  for buffer in pairs(client.attached_buffers) do
    maps(buffer)
  end
end
vim.keymap.set("n", "<leader>ux", function()
  if require("illuminate.engine").is_paused() then
    illuminate.resume()
  else
    illuminate.pause()
  end
end, { desc = "Toggle reference highlights" })
