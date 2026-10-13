-- Dependencies: neocmakelsp (neocmakelsp release); cmake; cmake-format (pip cmakelang); cmakelint (pip cmakelint).
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Plugins: Civitasv/cmake-tools.nvim + plenary.nvim; https://github.com/Civitasv/cmake-tools.nvim
-- Parsers (install manually): cmake.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- cmake-tools is loaded at startup; its build/configure commands run only when invoked.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({
  { src = "https://github.com/Civitasv/cmake-tools.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
})
require("cmake-tools").setup({})
vim.lsp.config("neocmake", {})
vim.lsp.enable("neocmake")
require("lint").linters_by_ft.cmake = { "cmakelint" }
require("conform").formatters_by_ft.cmake = { "cmake_format" }
