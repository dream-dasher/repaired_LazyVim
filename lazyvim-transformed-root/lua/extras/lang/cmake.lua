-- Dependencies: neocmakelsp (neocmakelsp release); cmake; cmake-format (pip cmakelang); cmakelint (pip cmakelint).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Plugins: Civitasv/cmake-tools.nvim + plenary.nvim; https://github.com/Civitasv/cmake-tools.nvim
-- Parsers (install manually): cmake.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- cmake-tools is loaded at startup; its build/configure commands run only when invoked.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Load CMake commands and their Lua utility dependency at startup.
vim.pack.add({
  { src = "https://github.com/Civitasv/cmake-tools.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
})
-- Register build/configure commands; builds occur when commands are invoked.
require("cmake-tools").setup({})
-- Enable CMake language support from the native server definition.
vim.lsp.config("neocmake", {})
vim.lsp.enable("neocmake")
-- Use external CMake linting and formatting through the existing core hooks.
require("lint").linters_by_ft.cmake = { "cmakelint" }
require("conform").formatters_by_ft.cmake = { "cmake_format" }
