-- Dependencies: Neovim 0.12.6; Git for vim.pack; inc-rename.nvim; LSP rename support.
-- Docs: https://github.com/smjonas/inc-rename.nvim
-- Enable: require("extras.editor.inc-rename") in init.lua.
-- Load AFTER plugins/lsp.lua and config/keymaps.lua; replaces <leader>cr.
-- For Noice's rename popup, directly set presets.inc_rename=true in plugins/ui.lua's noice.setup options.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load live-preview LSP renaming.
vim.pack.add({ "https://github.com/smjonas/inc-rename.nvim" })
require("inc_rename").setup({})
--- Install the rename key globally, or locally when a buffer is supplied.
--- Return an editable command line prefilled with the cursor word; do not execute it yet.
local function map(buffer)
  vim.keymap.set("n", "<leader>cr", function()
    return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
  end, { expr = true, buffer = buffer, desc = "Incremental rename" })
end
-- Provide a global rename mapping before clients attach.
map()
-- Replace the attaching buffer's native rename mapping with the preview command.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("config_inc_rename", { clear = true }),
  callback = function(event)
    map(event.buf)
  end,
})
-- Apply the replacement to buffers whose clients were already attached.
for _, client in ipairs(vim.lsp.get_clients()) do
  for buffer in pairs(client.attached_buffers) do
    map(buffer)
  end
end
