-- Dependencies: Neovim 0.12.6; Git for vim.pack; vim-startuptime; nvim executable.
-- Docs: https://github.com/dstein64/vim-startuptime
-- Enable: require("extras.util.startuptime") in init.lua.
-- Invoke :StartupTime manually. It launches additional editor instances with your config, which can trigger normal runtime writes/networking.
-- No startup profiling or subprocess is launched by this module itself.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.g.startuptime_tries = 10
vim.pack.add({ "https://github.com/dstein64/vim-startuptime" })
