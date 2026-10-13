-- Dependencies: Neovim 0.12.6; Git for vim.pack; octo.nvim; plenary.nvim; GitHub CLI (`gh`) installed/authenticated manually; default Snacks picker and icon provider; optional markdown parser.
-- Docs: https://github.com/pwntester/octo.nvim
-- Enable: require("extras.util.octo") in init.lua.
-- Run `gh auth login` explicitly before use. Projects v2 requires manually granting read:project/project scope when needed.
-- Load after config/keymaps.lua; replaces Snacks GitHub issue/PR mappings. Choose GH or Octo workflow, or distinct keys.
-- Writing an Octo buffer syncs with GitHub; no remote writes/auth happen from this setup.
-- Picker is explicit: change 'snacks' below to 'telescope', 'fzf-lua', or 'default' if replacing the default picker.
-- Dropped: session ExitPre buftype mutation and automatic Git-extra import; enable extras.lang.git separately if wanted.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim", "https://github.com/pwntester/octo.nvim" })
require("octo").setup({
  enable_builtin = true,
  default_to_projects_v2 = true,
  default_merge_method = "squash",
  picker = "snacks",
})
vim.treesitter.language.register("markdown", "octo")
for key, command in pairs({
  gi = "Octo issue list",
  gI = "Octo issue search",
  gp = "Octo pr list",
  gP = "Octo pr search",
  gr = "Octo repo list",
  gS = "Octo search",
}) do
  vim.keymap.set("n", "<leader>" .. key, "<cmd>" .. command .. "<cr>", { desc = command })
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "octo",
  callback = function(event)
    vim.keymap.set("i", "@", "@<C-x><C-o>", { buffer = event.buf, desc = "Complete GitHub user" })
    vim.keymap.set("i", "#", "#<C-x><C-o>", { buffer = event.buf, desc = "Complete issue" })
  end,
})
