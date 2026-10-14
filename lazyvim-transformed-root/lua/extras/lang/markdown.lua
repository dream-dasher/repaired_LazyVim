-- Dependencies: marksman (release); node; prettier, markdownlint-cli2, markdown-toc (npm packages); optional node/yarn for manually prepared browser preview.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Plugins: iamcco/markdown-preview.nvim + MeanderingProgrammer/render-markdown.nvim.
-- Parsers (install manually): markdown, markdown_inline.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Preview manual preparation AFTER reviewing the install procedure: :call mkdp#util#install()
-- (or the documented node/yarn setup); no build/download hook runs from this config.
-- Preview docs: https://github.com/iamcco/markdown-preview.nvim#installation--usage
-- Rendering: https://github.com/MeanderingProgrammer/render-markdown.nvim
-- Enable this AFTER extras.formatting.prettier so TOC/lint formatting steps remain.
-- Markman + markdownlint diagnostics may overlap but cover distinct features.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Recognize MDX files and reuse the Markdown parser for their outer document.
vim.filetype.add({ extension = { mdx = "markdown.mdx" } })
vim.treesitter.language.register("markdown", "markdown.mdx")
-- Enable Marksman for Markdown navigation and language diagnostics.
vim.lsp.config("marksman", {})
vim.lsp.enable("marksman")
-- Format the document, apply Markdown lint fixes, then update an opted-in TOC.
local conform = require("conform")
for _, ft in ipairs({ "markdown", "markdown.mdx" }) do
  conform.formatters_by_ft[ft] = { "prettier", "markdownlint-cli2", "markdown-toc" }
end
-- Only regenerate the TOC in buffers containing the explicit HTML marker.
conform.formatters["markdown-toc"] = {
  -- Inspect the buffer supplied by Conform rather than whichever buffer is current.
  condition = function(_, ctx)
    for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
      if line:find("<!%-%- toc %-%->") then
        return true
      end
    end
    return false
  end,
}
-- Only run the lint-fix formatting step after Markdown lint reports diagnostics.
conform.formatters["markdownlint-cli2"] = {
  condition = function(_, ctx)
    for _, diagnostic in ipairs(vim.diagnostic.get(ctx.buf)) do
      if diagnostic.source == "markdownlint" then
        return true
      end
    end
    return false
  end,
}
-- Keep Markdown/MDX lint diagnostics available through the core lint hooks.
local lint = require("lint")
lint.linters_by_ft.markdown = { "markdownlint-cli2" }
lint.linters_by_ft["markdown.mdx"] = { "markdownlint-cli2" }
-- Load browser preview commands and the in-buffer document renderer.
vim.pack.add({
  { src = "https://github.com/iamcco/markdown-preview.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})
-- Allow browser preview in Markdown/MDX and render supported document buffers.
vim.g.mkdp_filetypes = { "markdown", "markdown.mdx" }
require("render-markdown").setup({
  file_types = { "markdown", "markdown.mdx", "norg", "rmd", "org", "codecompanion", "livebook" },
  code = { sign = false, width = "block", right_pad = 1 },
  heading = { sign = false, icons = {} },
  checkbox = { enabled = false },
})
-- Provide a mapping to toggle in-buffer rendering independently of browser preview.
vim.keymap.set("n", "<leader>um", require("render-markdown").toggle, { desc = "Toggle Render Markdown" })
-- On Markdown/MDX filetype detection, add a buffer-local browser-preview toggle.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("MarkdownPreviewMappings", { clear = true }),
  pattern = { "markdown", "markdown.mdx" },
  callback = function(event)
    vim.keymap.set(
      "n",
      "<leader>cp",
      "<cmd>MarkdownPreviewToggle<cr>",
      { buffer = event.buf, desc = "Markdown Preview" }
    )
  end,
})
