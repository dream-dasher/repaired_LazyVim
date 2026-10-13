-- Dependencies: PHP; phpactor (Composer phpactor/phpactor); phpcs (Composer squizlabs/php_codesniffer); php-cs-fixer (Composer friendsofphp/php-cs-fixer); optional php-debug-adapter.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim), plugins.linting (nvim-lint).
-- Parsers (install manually): php.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Choose exactly one PHP language server; phpactor and intelephense duplicate LSP features.
-- PHP debugger: install an executable wrapper for https://github.com/xdebug/vscode-php-debug ; configure Xdebug manually.
-- Optional tests: in extras.test.core add V13Axel/neotest-pest + olimorris/neotest-phpunit to vim.pack.add
-- and adapters require("neotest-pest") and require("neotest-phpunit")({ root_ignore_files = { "tests/Pest.php" } }).
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.lsp.config("phpactor", {})
vim.lsp.enable("phpactor")
-- Alternative: replace both phpactor lines with intelephense (npm intelephense; needs node).
require("conform").formatters_by_ft.php = { "php_cs_fixer" }
require("lint").linters_by_ft.php = { "phpcs" }
local ok, dap = pcall(require, "dap")
if ok then
  dap.adapters.php = { type = "executable", command = "php-debug-adapter", args = {} }
end
