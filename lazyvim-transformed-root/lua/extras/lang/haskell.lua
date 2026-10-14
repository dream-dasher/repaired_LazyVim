-- Dependencies: ghc, cabal or stack; haskell-language-server-wrapper (GHCup); fourmolu, cabal-fmt, hlint (Haskell packages); optional hoogle/haskell-debugger.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Plugins: mrcjkb/haskell-tools.nvim v10; https://github.com/mrcjkb/haskell-tools.nvim
-- Parsers (install manually): haskell.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Toolchain: https://www.haskell.org/ghcup/
-- Haskell plugin retains its own FileType initialization; package-manager lazy loading is removed.
-- Optional tests: enable extras.test.core; add https://github.com/mrcjkb/neotest-haskell
-- to its vim.pack.add list and require("neotest-haskell") to its adapters table.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Set options before vim.pack.add loads the plugin's filetype scripts.
vim.g.haskell_tools = {
  hls = {
    cmd = { "haskell-language-server-wrapper", "--lsp" },
    capabilities = require("blink.cmp").get_lsp_capabilities(),
  },
  tools = { tags = { enable = false } }, -- no background fast-tags generation
}
vim.pack.add({ { src = "https://github.com/mrcjkb/haskell-tools.nvim", version = vim.version.range("^10") } })
-- Single owner: haskell-tools attaches HLS. Do not also vim.lsp.enable("hls").
-- On Haskell filetype detection, add buffer-local evaluation, Hoogle, and REPL
-- mappings; the buffer REPL passes the current file rather than the package root.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("HaskellMappings", { clear = true }),
  pattern = { "haskell", "lhaskell" },
  callback = function(event)
    local ht = require("haskell-tools")
    vim.keymap.set("n", "<localleader>e", "<cmd>Haskell hls evalAll<cr>", { buffer = event.buf, desc = "Evaluate All" })
    vim.keymap.set("n", "<localleader>h", ht.hoogle.hoogle_signature, { buffer = event.buf, desc = "Hoogle Signature" })
    vim.keymap.set("n", "<localleader>r", ht.repl.toggle, { buffer = event.buf, desc = "REPL (Package)" })
    vim.keymap.set("n", "<localleader>R", function()
      ht.repl.toggle(vim.api.nvim_buf_get_name(event.buf))
    end, { buffer = event.buf, desc = "REPL (Buffer)" })
  end,
})
-- Format Haskell/Cabal with their CLI tools and lint Haskell through hlint.
local conform = require("conform")
conform.formatters_by_ft.haskell = { "fourmolu" }
conform.formatters_by_ft.cabal = { "cabal_fmt" }
require("lint").linters_by_ft.haskell = { "hlint" }
-- Optional LuaSnip snippets (enable extras.coding.luasnip first):
-- vim.pack.add({ { src = "https://github.com/mrcjkb/haskell-snippets.nvim" } })
-- require("luasnip").add_snippets("haskell", require("haskell-snippets").all, { key = "haskell" })
-- Optional Telescope Hoogle uses the extension supplied by haskell-tools itself:
-- require("telescope").load_extension("ht")
-- vim.keymap.set("n", "<localleader>H", "<cmd>Telescope ht hoogle_signature<cr>", { desc = "Hoogle" })
