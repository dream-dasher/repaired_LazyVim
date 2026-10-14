-- Dependencies: Neovim 0.12.6; Git for vim.pack; vim-illuminate; optional LSP/Tree-sitter parsers.
-- Docs: https://github.com/RRethy/vim-illuminate
-- Enable: require("extras.editor.illuminate") in init.lua.
-- Set words.enabled=false directly in plugins/snacks.lua before enabling this alternative.
-- Load after config/keymaps.lua. Conflicts: replaces [[/]] reference navigation and <leader>ux toggle.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load reference highlighting, with a short delay and LSP-only handling for large buffers.
vim.pack.add({ "https://github.com/RRethy/vim-illuminate" })
local illuminate = require("illuminate")
illuminate.configure({ delay = 200, large_file_cutoff = 2000, large_file_overrides = { providers = { "lsp" } } })
--- Install reference-navigation keys globally, or locally when a buffer is supplied.
--- Passing false disables wrapping past the first or last reference.
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
-- Provide global navigation defaults before filetype/LSP-specific mappings are installed.
maps()
-- Reapply local reference-navigation mappings when a buffer receives its filetype.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config_illuminate", { clear = true }),
  callback = function(event)
    maps(event.buf)
  end,
})
-- Restore reference-navigation mappings after core LSP mappings are installed on attachment.
vim.api.nvim_create_autocmd("LspAttach", {
  group = "config_illuminate",
  callback = function(event)
    maps(event.buf)
  end,
})
-- Update buffers whose LSP clients were already attached before this module loaded.
for _, client in ipairs(vim.lsp.get_clients()) do
  for buffer in pairs(client.attached_buffers) do
    maps(buffer)
  end
end
-- Pause or resume reference highlighting according to the engine's current state.
vim.keymap.set("n", "<leader>ux", function()
  if require("illuminate.engine").is_paused() then
    illuminate.resume()
  else
    illuminate.pause()
  end
end, { desc = "Toggle reference highlights" })
