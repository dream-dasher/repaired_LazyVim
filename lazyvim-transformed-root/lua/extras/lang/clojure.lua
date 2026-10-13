-- Dependencies: clojure + a project nREPL (Clojure CLI / Leiningen); optional clojure-lsp if uncommented below.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: Olical/conjure, julienvincent/nvim-paredit, m00qek/baleia.nvim, PaterJason/cmp-conjure, blink.compat v2.
-- Parsers (install manually): clojure.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Conjure: https://github.com/Olical/conjure ; Paredit: https://github.com/julienvincent/nvim-paredit
-- Conjure connects to your manually started REPL; no REPL is started by this module.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

vim.g["conjure#log#strip_ansi_escape_sequences_line_limit"] = 0
vim.g["conjure#mapping#doc_word"] = "K"
vim.g["conjure#mapping#def_word"] = "gd"
vim.pack.add({
  { src = "https://github.com/julienvincent/nvim-paredit" },
  { src = "https://github.com/m00qek/baleia.nvim" },
  { src = "https://github.com/Olical/conjure" },
  { src = "https://github.com/PaterJason/cmp-conjure" },
  { src = "https://github.com/saghen/blink.compat", version = vim.version.range("2") },
})
require("nvim-paredit").setup({})
local baleia = require("baleia").setup({ line_starts_at = 3 })
vim.api.nvim_create_user_command("BaleiaColorize", function()
  baleia.once(vim.api.nvim_get_current_buf())
end, { bang = true })
vim.api.nvim_create_user_command("BaleiaLogs", baleia.logger.show, { bang = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("ConjureLog", { clear = true }),
  pattern = "conjure-log-*",
  callback = function(event)
    vim.diagnostic.enable(false, { bufnr = event.buf })
    baleia.automatically(event.buf)
    vim.keymap.set(
      { "n", "x" },
      "[c",
      "<cmd>call search('^; -\\+$', 'bw')<cr>",
      { buffer = event.buf, desc = "Previous evaluation output" }
    )
    vim.keymap.set(
      { "n", "x" },
      "]c",
      "<cmd>call search('^; -\\+$', 'w')<cr>",
      { buffer = event.buf, desc = "Next evaluation output" }
    )
  end,
})
require("conjure.main").main()
require("blink.compat").setup({})
local blink = require("blink.cmp")
blink.add_source_provider("conjure", { name = "conjure", module = "blink.compat.source" })
for _, ft in ipairs({ "clojure", "fennel", "scheme" }) do
  blink.add_filetype_source(ft, "conjure")
end
-- Optional static analysis/navigation alongside the REPL:
-- vim.lsp.config("clojure_lsp", {})
-- vim.lsp.enable("clojure_lsp")
