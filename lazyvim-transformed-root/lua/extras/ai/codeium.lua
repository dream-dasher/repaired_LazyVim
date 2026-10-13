-- Dependencies: Neovim 0.12.6; Git for vim.pack; windsurf.nvim (formerly codeium.nvim); plenary.nvim; manually downloaded Codeium language server; curl/uuidgen; account/auth.
-- Docs: https://github.com/Exafunction/windsurf.nvim
-- Enable: require("extras.ai.codeium") in init.lua.
-- Download the matching language_server release manually from https://github.com/Exafunction/codeium/releases and put it on PATH as codeium-language-server.
-- Check plugin lua/codeium/versions.lua for matching server version. Existing tools.language_server prevents download on setup.
-- Authenticate explicitly with :Codeium Auth; keys use Alt-l/Alt-]/Alt-[ instead of replacing Blink Tab.
-- Conflicts: choose one inline AI provider. To use Blink menu directly edit sources with module='codeium.blink', name='Codeium', async=true and disable virtual_text.enabled here.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim", "https://github.com/Exafunction/windsurf.nvim" })
local server = vim.fn.exepath("codeium-language-server")
if server == "" then
  vim.notify(
    "Manually install the Codeium server as codeium-language-server on PATH before enabling this extra.",
    vim.log.levels.WARN
  )
  return
end
require("codeium").setup({
  tools = { language_server = server },
  enable_cmp_source = false,
  virtual_text = {
    enabled = true,
    key_bindings = { accept = "<M-l>", next = "<M-]>", prev = "<M-[>" },
  },
})
