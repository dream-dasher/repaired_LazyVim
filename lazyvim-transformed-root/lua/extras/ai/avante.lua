-- Dependencies: Neovim 0.12.6; Git for vim.pack; avante.nvim; plenary.nvim; nui.nvim; mega.cmdparse/mega.logging; Copilot from extras.ai.copilot; curl/tar/make (or Rust/Cargo for source builds).
-- Docs: https://github.com/yetone/avante.nvim
-- Enable: require("extras.ai.avante") in init.lua.
-- Load AFTER colorscheme/plugins.ui and extras.ai.copilot; provider='copilot' uses that authenticated plugin.
-- Manual native libraries: review/run `make` in Avante checkout (downloads prebuilt libraries), or `make BUILD_FROM_SOURCE=true` with Rust/Cargo.
-- Windows manual equivalent: review Build.ps1 before invoking. No PackChanged/build hook is installed here.
-- Conflicts: <leader>a keys overlap other chat frontends; choose one or edit keys.
-- Optional image pasting: configure img-clip explicitly; optional rendering: add 'Avante' to render-markdown file_types in markdown.lua.
-- Optional Blink mentions: manually add Kaiser-Yang/blink-cmp-avante URL and module='blink-cmp-avante' provider to plugins/blink.lua.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Make Avante and its Lua dependencies available; native libraries are installed manually.
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/ColinKennedy/mega.logging",
  "https://github.com/ColinKennedy/mega.cmdparse",
  "https://github.com/yetone/avante.nvim",
})
-- Use the existing Copilot provider and keep all Avante mappings explicit below.
require("avante").setup({
  provider = "copilot",
  selection = { hint_display = "none" },
  behaviour = { auto_set_keymaps = false },
})
-- Expose chat, editing, history, and provider commands in normal and visual mode.
for key, command in pairs({
  aa = "AvanteAsk",
  ac = "AvanteChat",
  ae = "AvanteEdit",
  af = "AvanteFocus",
  ah = "AvanteHistory",
  am = "AvanteModels",
  an = "AvanteChatNew",
  ap = "AvanteSwitchProvider",
  ar = "AvanteRefresh",
  as = "AvanteStop",
  at = "AvanteToggle",
}) do
  vim.keymap.set({ "n", "x" }, "<leader>" .. key, "<cmd>" .. command .. "<cr>", { desc = command })
end
