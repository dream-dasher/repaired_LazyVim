-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.indentscope; no external executable.
-- Docs: https://github.com/nvim-mini/mini.indentscope
-- Enable: require("extras.ui.mini-indentscope") in init.lua.
-- Set indent.scope.enabled=false directly in plugins/snacks.lua; if using ibl set its scope.enabled=false.
-- Conflicts: duplicate scope renderers should be disabled; Snacks scope navigation may remain enabled.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/nvim-mini/mini.indentscope" })
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config_mini_indentscope", { clear = true }),
  pattern = {
    "Trouble",
    "alpha",
    "dashboard",
    "fzf",
    "help",
    "neo-tree",
    "sidekick_terminal",
    "snacks_dashboard",
    "snacks_notif",
    "snacks_terminal",
    "snacks_win",
    "trouble",
  },
  callback = function(event)
    vim.b[event.buf].miniindentscope_disable = true
  end,
})
require("mini.indentscope").setup({ symbol = "│", options = { try_as_border = true } })
