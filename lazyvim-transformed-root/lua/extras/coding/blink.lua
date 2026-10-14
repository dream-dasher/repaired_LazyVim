-- Dependencies: Neovim 0.12.6; Git for vim.pack; saghen/blink.cmp and friendly-snippets (default plugins/blink.lua).
-- Docs: https://cmp.saghen.dev/
-- Enable: require("extras.coding.blink") in init.lua.
-- Already enabled by require("plugins.blink"); this optional line is only a readable alias.
-- Conflicts: use either Blink or extras.coding.nvim-cmp, never both.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Reuse the default Blink module; require caches it if it has already run.
require("plugins.blink")
