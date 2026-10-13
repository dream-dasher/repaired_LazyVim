-- Dependencies: git, curl; optional gh (GitHub CLI) / glab (GitLab CLI) for issue completion.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Plugins: petertriho/cmp-git (native Blink source); https://github.com/petertriho/cmp-git
-- Parsers (install manually): git_config, gitcommit, git_rebase, gitignore, gitattributes.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Completion can query Git remotes or GitHub when requested; authorize/configure gh separately.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Package installation: git via native vim.pack.

-- Git syntax is supplied by the manually installed parsers.
-- Preserve Git completion through the plugin's native Blink provider.
vim.pack.add({
  { src = "https://github.com/petertriho/cmp-git" },
})
local blink = require("blink.cmp")
blink.add_source_provider("git", { name = "git", module = "cmp_git.blink" })
blink.add_filetype_source("gitcommit", "git")
