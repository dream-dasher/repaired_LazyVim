-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-navic; LSP with documentSymbol support; optional lualine already in plugins/ui.lua.
-- Docs: https://github.com/SmiteshP/nvim-navic
-- Enable: require("extras.editor.navic") in init.lua.
-- Load after plugins/lsp.lua. Directly add {'navic',color_correction='dynamic'} to lualine_c in plugins/ui.lua.
-- Conflicts: symbol breadcrumbs from Trouble/Aerial can duplicate Navic in lualine; choose one component.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/SmiteshP/nvim-navic" })
vim.g.navic_silence = true
local navic = require("nvim-navic")
navic.setup({
  separator = " ",
  highlight = true,
  depth_limit = 5,
  icons = require("config.icons").kinds,
  lazy_update_context = true,
})
local function attach(client, buffer)
  if client:supports_method("textDocument/documentSymbol", buffer) then
    navic.attach(client, buffer)
  end
end
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("config_navic", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      attach(client, event.buf)
    end
  end,
})
for _, client in ipairs(vim.lsp.get_clients()) do
  for buffer in pairs(client.attached_buffers) do
    attach(client, buffer)
  end
end
