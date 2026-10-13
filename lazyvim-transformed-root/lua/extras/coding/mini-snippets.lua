-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.snippets; friendly-snippets; no external executable.
-- Docs: https://github.com/nvim-mini/mini.snippets
-- Enable: require("extras.coding.mini-snippets") in init.lua.
-- Place this call BEFORE require("plugins.blink"); directly set snippets.preset = "mini_snippets" in plugins/blink.lua.
-- Conflicts: replaces native vim.snippet; mutually exclusive with LuaSnip.
-- Custom global snippets example: add snippets.gen_loader.from_file(stdpath('config')..'/snippets/global.json') before from_lang().
-- To keep standalone snippets out of the completion menu, remove 'snippets' from Blink sources.default.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({
  "https://github.com/nvim-mini/mini.snippets",
  "https://github.com/rafamadriz/friendly-snippets",
})
local snippets = require("mini.snippets")
snippets.setup({
  snippets = { snippets.gen_loader.from_lang() },
  -- <C-j> expands; <C-l>/<C-h> navigate; <C-c> stops (plugin defaults).
})
