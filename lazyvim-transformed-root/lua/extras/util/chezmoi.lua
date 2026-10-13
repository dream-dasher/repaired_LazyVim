-- Dependencies: Neovim 0.12.6; Git for vim.pack; chezmoi.nvim; chezmoi.vim; plenary.nvim; chezmoi executable installed manually.
-- Docs: https://github.com/xvzc/chezmoi.nvim
-- Enable: require("extras.util.chezmoi") in init.lua.
-- Load after plugins/snacks.lua. Editing managed dotfiles can write outside the config; changes occur on explicit ChezmoiEdit/save.
-- Dropped: automatic file-enter watch/apply and dashboard option injection. No background dotfile watcher is started here.
-- To add a dashboard shortcut, directly call the <leader>sz action from your chosen dashboard setup.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.g["chezmoi#use_tmp_buffer"] = 1
vim.g["chezmoi#source_dir_path"] = vim.fs.joinpath(vim.uv.os_homedir(), ".local", "share", "chezmoi")
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/alker0/chezmoi.vim",
  "https://github.com/xvzc/chezmoi.nvim",
})
require("chezmoi").setup({
  edit = { watch = false, force = false },
  notification = { on_open = true, on_apply = true, on_watch = false },
})
vim.keymap.set("n", "<leader>sz", function()
  local results = require("chezmoi.commands").list({
    args = { "--path-style", "absolute", "--include", "files", "--exclude", "externals" },
  })
  vim.ui.select(results, { prompt = "Chezmoi managed file" }, function(path)
    if path then
      require("chezmoi.commands").edit({ targets = { path }, args = {} })
    end
  end)
end, { desc = "Chezmoi files" })
