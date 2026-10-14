-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-mini/mini.surround; no external executable.
-- Docs: https://github.com/nvim-mini/mini.surround
-- Enable: require("extras.coding.mini-surround") in init.lua.
-- Load after plugins/coding.lua. With Leap, change every gs prefix below to gz.
-- Conflicts: Leap uses gs; choose distinct keys by directly editing this table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load surround editing and keep its actions grouped under the gs prefix.
vim.pack.add({ "https://github.com/nvim-mini/mini.surround" })
require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },
})
