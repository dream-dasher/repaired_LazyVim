-- Dependencies: clangd + clang-format (LLVM); optional codelldb (CodeLLDB release) for extras.dap.core.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Plugins: p00f/clangd_extensions.nvim; https://github.com/p00f/clangd_extensions.nvim
-- Parsers (install manually): c, cpp, cuda.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Native Neovim inlay hints replace the removed extension inlay_hints option.
-- nvim-cmp-specific clangd completion sorting is omitted for Blink.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.pack.add({ { src = "https://github.com/p00f/clangd_extensions.nvim" } })
require("clangd_extensions").setup({
  ast = {
    role_icons = {
      type = "",
      declaration = "",
      expression = "",
      specifier = "",
      statement = "",
      ["template argument"] = "",
    },
    kind_icons = {
      Compound = "",
      Recovery = "",
      TranslationUnit = "",
      PackExpansion = "",
      TemplateTypeParm = "",
      TemplateTemplateParm = "",
      TemplateParamObject = "",
    },
  },
})
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    "Makefile",
    "configure.in",
    "config.h.in",
    "meson.build",
    "meson_options.txt",
    "build.ninja",
    ".git",
  },
  capabilities = { offsetEncoding = { "utf-16" } },
  init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
  on_attach = function(_, buf)
    vim.keymap.set(
      "n",
      "<leader>ch",
      "<cmd>ClangdSwitchSourceHeader<cr>",
      { buffer = buf, desc = "Switch Source/Header (C/C++)" }
    )
  end,
})
vim.lsp.enable("clangd")
local conform = require("conform")
for _, ft in ipairs({ "c", "cpp", "objc", "objcpp", "cuda" }) do
  conform.formatters_by_ft[ft] = { "clang_format" }
end

local ok, dap = pcall(require, "dap")
if ok then
  dap.adapters.codelldb = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = { command = "codelldb", args = { "--port", "${port}" } },
  }
  for _, ft in ipairs({ "c", "cpp" }) do
    dap.configurations[ft] = {
      {
        type = "codelldb",
        request = "launch",
        name = "Launch file",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
      },
      {
        type = "codelldb",
        request = "attach",
        name = "Attach to process",
        pid = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
  end
end
