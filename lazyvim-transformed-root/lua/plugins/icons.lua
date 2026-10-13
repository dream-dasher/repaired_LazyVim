-- External dependencies: a Nerd Font in the terminal is recommended; none required.
-- Plugin dependencies: nvim-mini/mini.icons. Manual builds: none.
-- Docs: https://nvim-mini.org/mini.nvim/doc/mini-icons.html
-- Load before other UI modules. The documented shim lets plugins expecting
-- nvim-web-devicons use these same icons without installing a second icon plugin.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({ { src = "https://github.com/nvim-mini/mini.icons" } })
local icons = require("mini.icons")
icons.setup({
  file = {
    [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
    ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
  },
  filetype = { dotenv = { glyph = "", hl = "MiniIconsYellow" } },
})
icons.mock_nvim_web_devicons()
