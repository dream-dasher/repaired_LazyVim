-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-lspconfig from plugins/lsp.lua; bash-language-server + Node; optional ShellCheck; manually installed parsers bash/git_config/fish/hyprlang/rasi.
-- Docs: https://github.com/bash-lsp/bash-language-server
-- Enable: require("extras.util.dot") in init.lua.
-- Load after plugins/lsp.lua and plugins/treesitter.lua. Install server and ShellCheck through your OS/Node tools.
-- Parser installation is explicit: see plugins/treesitter.lua; this module only associates filetypes.
-- Removed: scanning external XDG config directories to choose parser installs.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.filetype.add({
  extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
  filename = { vifmrc = "vim" },
  pattern = {
    [".*/waybar/config"] = "jsonc",
    [".*/mako/config"] = "dosini",
    [".*/kitty/.+%.conf"] = "kitty",
    [".*/hypr/.+%.conf"] = "hyprlang",
    ["%.env%.[%w_.-]+"] = "sh",
  },
})
vim.treesitter.language.register("bash", "kitty")
if vim.fn.executable("bash-language-server") == 1 then
  vim.lsp.config("bashls", { cmd = { "bash-language-server", "start" } })
  vim.lsp.enable("bashls")
end
