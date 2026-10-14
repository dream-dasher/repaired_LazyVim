-- Dependencies: tinymist (release); typstyle (release); websocat (release) for preview; typst for standalone CLI compilation.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Plugins: chomosuke/typst-preview.nvim; optional folke/ts-comments.nvim.
-- Parsers (install manually): typst.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Both preview binaries are explicitly provided, preventing the plugin from downloading them.
-- Preview: https://github.com/chomosuke/typst-preview.nvim
-- Tinymist: https://github.com/Myriad-Dreamin/tinymist ; https://github.com/typstyle-rs/typstyle
-- Conform prefers Tinymist LSP formatting and falls back to typstyle.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Load preview commands and use explicit binaries instead of plugin downloads.
vim.pack.add({ { src = "https://github.com/chomosuke/typst-preview.nvim" } })
require("typst-preview").setup({ dependencies_bin = { tinymist = "tinymist", websocat = "websocat" } })
-- Configure Tinymist language support with typstyle-based formatting.
vim.lsp.config("tinymist", {
  settings = { formatterMode = "typstyle" },
  -- Add a mapping that pins this buffer's file as Tinymist's main document.
  on_attach = function(client, buf)
    vim.keymap.set("n", "<leader>cP", function()
      local filename = vim.api.nvim_buf_get_name(buf)
      client:exec_cmd({ command = "tinymist.pinMain", arguments = { filename } }, { bufnr = buf })
      vim.notify("Tinymist: Pinned " .. vim.fs.basename(filename))
    end, { buffer = buf, desc = "Pin Main File" })
  end,
})
vim.lsp.enable("tinymist")
-- Prefer Tinymist LSP formatting, with the typstyle CLI as a fallback.
require("conform").formatters_by_ft.typst = { "typstyle", lsp_format = "prefer" }
-- On Typst filetype detection, set line-comment syntax and add preview toggling.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TypstMappings", { clear = true }),
  pattern = "typst",
  callback = function(event)
    vim.bo[event.buf].commentstring = "// %s"
    vim.keymap.set(
      "n",
      "<leader>cp",
      "<cmd>TypstPreviewToggle<cr>",
      { buffer = event.buf, desc = "Toggle Typst Preview" }
    )
  end,
})
-- If ts-comments is loaded, provide both line and block comment forms.
local ok, comments = pcall(require, "ts-comments.config")
if ok then
  comments.options.lang.typst = { "// %s", "/* %s */" }
end
