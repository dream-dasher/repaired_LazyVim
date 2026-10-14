-- Dependencies: Neovim >= 0.12.6; git for native vim.pack plugin installation.
-- Default external tools: rg, lua-language-server, stylua; fd recommended; shfmt and fish for their filetypes.
-- Optional: lazygit, gh, a clipboard provider and a Nerd Font.
-- Manual Tree-sitter builds: curl, tar, a C compiler and tree-sitter CLI >= 0.26.1.
-- Each module repeats its dependencies; optional modules below are ordinary commented calls.
-- Docs: https://neovim.io/doc/user/pack/ and https://neovim.io/doc/user/lsp/
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
-- Check the minimum supported Neovim version before configuring plugins.
if vim.fn.has("nvim-0.12.6") == 0 then
  error("This configuration requires Neovim >= 0.12.6")
end

-- Also works with `nvim -u /path/to/this/init.lua`: expose THIS config's Lua and queries.
local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(config_dir)

-- Establish editor options and the UI services used by the mappings below.
-- Every module runs immediately here; this order is the configuration's startup flow.
require("config.options") -- rg for :grep; optional clipboard provider / Nerd Font.
require("plugins.icons") -- mini.icons; Nerd Font recommended.
require("plugins.colorscheme") -- TokyoNight; no external tools.
-- require("plugins.catppuccin") -- Catppuccin; replace the TokyoNight call above.
require("plugins.snacks") -- Snacks; rg/fd/git; gh/lazygit and image tools optional.
require("config.autocmds") -- Native autocmds; creates parent directories when explicitly saving.
require("config.keymaps") -- Snacks/Conform on use; lazygit optional. No distribution management keys.
require("plugins.coding") -- mini.pairs/ai, ts-comments, lazydev; no external tools.

-- Optional snippet alternatives go BEFORE Blink; also edit its snippets.preset as documented.
-- require("extras.coding.luasnip") -- LuaSnip; optional make/C compiler for jsregexp.
-- require("extras.coding.mini-snippets") -- mini.snippets; choose instead of LuaSnip/native snippets.
-- Also edit Blink sources/providers directly as described in this optional module.
-- Dependencies: Neovim 0.12.6; Git for vim.pack; cmp-tabnine; blink.compat for Blink (default) or nvim-cmp; manually installed Tabnine binary; curl/unzip or PowerShell for manual installer.
-- require("extras.ai.tabnine")

-- Configure completion before LSP setup asks Blink for client capabilities.
require("plugins.blink") -- Blink + friendly-snippets; Lua fuzzy matching, no binary build/download.
-- require("extras.coding.nvim-cmp") -- Replace Blink above and its capability call in plugins/lsp.lua.

require("plugins.treesitter") -- TS main/textobjects/autotag; MANUAL parser installation only.
-- Manual: :TSInstall bash c diff html javascript jsdoc json lua luadoc luap markdown
--   markdown_inline printf python query regex toml tsx typescript vim vimdoc xml yaml
-- Needs curl, tar, C compiler and tree-sitter >= 0.26.1; after plugin updates run :TSUpdate.
require("plugins.editor") -- Flash/WhichKey/Gitsigns/GrugFar/Trouble/Todo; git and rg.
require("plugins.formatting") -- Conform; stylua, shfmt, fish_indent on PATH.
require("plugins.linting") -- nvim-lint; fish on PATH for Fish buffers.
-- Optional project JSON layering; only use with an explicit native before_init hook.
-- Optional lsp configurations and alternatives.
-- Dependencies: Neovim 0.12.6; Git for vim.pack; neoconf.nvim; optional jsonc parser; no external executable.
-- require("extras.lsp.neoconf")

-- Enable native language clients after completion, formatting, and linting are ready.
require("plugins.lsp") -- nvim-lspconfig definitions + native LSP; lua-language-server on PATH.
require("plugins.persistence") -- Persistence; writes sessions in Neovim's state directory.

-- Optional modules: uncomment ordinary calls and install the documented dependencies.
-- Alternatives can require direct edits to a default module; read their header first.
-- DAP/test precede language adapters; Prettier precedes Markdown; Black follows Python.
-- Snippet, Tabnine, nvim-cmp and Neoconf alternatives appear above their dependent defaults.

-- Debugging and tests: install adapters/runners manually; commands execute project code.
-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-dap; nvim-dap-ui; nvim-nio; nvim-dap-virtual-text; plenary.nvim; adapters installed manually per language.
-- require("extras.dap.core")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; one-small-step-for-vimkind; nvim-dap from extras.dap.core; nvim executable.
-- require("extras.dap.nlua")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; neotest; nvim-nio; plenary.nvim; nvim-treesitter; per-language adapters and test runners installed manually.
-- require("extras.test.core")

-- Optional coding configurations and alternatives.
-- Dependencies: Neovim 0.12.6; Git for vim.pack; saghen/blink.cmp and friendly-snippets (default plugins/blink.lua).
-- require("extras.coding.blink")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.comment; nvim-ts-context-commentstring; installed Tree-sitter parsers for contextual comments.
-- require("extras.coding.mini-comment")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-mini/mini.surround; no external executable.
-- require("extras.coding.mini-surround")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; neogen; nvim-treesitter and installed parser for the current language.
-- require("extras.coding.neogen")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; yanky.nvim; plenary.nvim; optional sqlite.lua + system SQLite library for persistent history.
-- require("extras.coding.yanky")

-- Optional editor configurations and alternatives.
-- These run after the core LSP/mapping setup and before plugins.ui below.
-- In particular, Aerial/Navic must be available when Lualine discovers its components.
-- Dependencies: Neovim 0.12.6; Git for vim.pack; aerial.nvim; LSP with documentSymbol support or installed Tree-sitter parsers.
-- require("extras.editor.aerial")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; dial.nvim; no external executable.
-- require("extras.editor.dial")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; fzf-lua; fzf executable; rg; fd optional; optional delta for code-action preview.
-- require("extras.editor.fzf")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; harpoon (harpoon2 branch); plenary.nvim.
-- require("extras.editor.harpoon2")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; vim-illuminate; optional LSP/Tree-sitter parsers.
-- require("extras.editor.illuminate")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; inc-rename.nvim; LSP rename support.
-- require("extras.editor.inc-rename")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; leap.nvim (Codeberg); vim-repeat; no external executable.
-- require("extras.editor.leap")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.diff; Git for its default source.
-- require("extras.editor.mini-diff")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.files; Snacks for LSP file-rename notifications (default plugins/snacks.lua).
-- require("extras.editor.mini-files")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.move; no external executable.
-- require("extras.editor.mini-move")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-navic; LSP with documentSymbol support; optional lualine already in plugins/ui.lua.
-- require("extras.editor.navic")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; neo-tree.nvim v3 branch; plenary.nvim; nui.nvim; default icon provider; Git for status.
-- require("extras.editor.neo-tree")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; outline.nvim; LSP with documentSymbol support.
-- require("extras.editor.outline")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; overseer.nvim; executables required by chosen task definitions (make, npm, etc.) installed manually.
-- require("extras.editor.overseer")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; refactoring.nvim; async.nvim; nvim-treesitter with parsers for supported languages.
-- require("extras.editor.refactoring")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; Snacks (already installed/configured in plugins/snacks.lua).
-- require("extras.editor.snacks_explorer")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; Snacks (already installed/configured in plugins/snacks.lua); rg and fd for searching.
-- require("extras.editor.snacks_picker")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; telescope.nvim; plenary.nvim; dressing.nvim; rg; fd optional. Optional telescope-fzf-native needs make/C compiler.
-- require("extras.editor.telescope")

-- Configure the UI after optional symbol providers have loaded. Lualine resolves
-- component modules during setup; providers loaded afterward can leave empty breadcrumbs.
-- To display Aerial/Navic, also add the component described in its module header to lualine_c.
require("plugins.ui") -- Bufferline/Lualine/Noice + nui; no external tools.

-- Optional ui configurations and alternatives.
-- Dependencies: Neovim 0.12.6; Git for vim.pack; alpha-nvim; default Snacks picker and persistence modules; rg/fd for search.
-- require("extras.ui.alpha")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; dashboard-nvim; default Snacks picker and persistence; rg/fd for search.
-- require("extras.ui.dashboard-nvim")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; edgy.nvim; default Trouble/Noice/Snacks; optional sidebars configured by direct edits below.
-- require("extras.ui.edgy")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; indent-blankline.nvim (ibl module); installed Tree-sitter parsers for scope.
-- require("extras.ui.indent-blankline")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.animate; no external executable.
-- require("extras.ui.mini-animate")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.indentscope; no external executable.
-- require("extras.ui.mini-indentscope")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.starter; default Snacks picker and persistence; rg/fd for search.
-- require("extras.ui.mini-starter")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; smear-cursor.nvim; no external executable.
-- require("extras.ui.smear-cursor")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-treesitter-context; installed Tree-sitter parsers.
-- require("extras.ui.treesitter-context")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; none-ls.nvim; plenary.nvim; fish/fish_indent; stylua; shfmt installed on PATH.
-- require("extras.lsp.none-ls")

-- Optional AI integrations: authenticate manually; choose providers/mappings directly.
-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-lspconfig; manually installed copilot-language-server on PATH; Copilot account/auth; native inline completion.
-- require("extras.ai.copilot-native")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; copilot.lua; Copilot subscription/auth; manually installed copilot-language-server executable (or an absolute custom binary path).
-- require("extras.ai.copilot")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; CopilotChat.nvim; plenary.nvim; curl >=8; Copilot Chat enabled in account; existing authenticated Copilot credentials.
-- require("extras.ai.copilot-chat")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; sidekick.nvim; nvim-lspconfig; manually installed copilot-language-server + Copilot auth for NES; AI CLI tools installed/authenticated separately.
-- require("extras.ai.sidekick")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; avante.nvim; plenary.nvim; nui.nvim; mega.cmdparse/mega.logging; Copilot from extras.ai.copilot; curl/tar/make (or Rust/Cargo for source builds).
-- require("extras.ai.avante")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; claudecode.nvim; Claude Code CLI (`claude`) installed manually and authenticated; default Snacks terminal.
-- require("extras.ai.claudecode")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; windsurf.nvim (formerly codeium.nvim); plenary.nvim; manually downloaded Codeium language server; curl/uuidgen; account/auth.
-- require("extras.ai.codeium")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; supermaven-nvim; manually installed sm-agent binary; Supermaven auth/account.
-- require("extras.ai.supermaven")

-- Optional utility integrations.
-- Dependencies: Neovim 0.12.6; Git for vim.pack; chezmoi.nvim; chezmoi.vim; plenary.nvim; chezmoi executable installed manually.
-- require("extras.util.chezmoi")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-lspconfig from plugins/lsp.lua; bash-language-server + Node; optional ShellCheck; manually installed parsers bash/git_config/fish/hyprlang/rasi.
-- require("extras.util.dot")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; gh.nvim; litee.nvim; Git; GitHub CLI (`gh`) installed and authenticated manually; default icon provider.
-- require("extras.util.gh")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; GitUI (`gitui`) and Git executables installed manually; default Snacks terminal.
-- require("extras.util.gitui")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; mini.hipatterns; no external executable.
-- require("extras.util.mini-hipatterns")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; octo.nvim; plenary.nvim; GitHub CLI (`gh`) installed/authenticated manually; default Snacks picker and icon provider; optional markdown parser.
-- require("extras.util.octo")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; project.nvim; default Snacks picker; optional Git/LSP roots.
-- require("extras.util.project")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; Kulala v5.3.4; curl; manually installed kulala_http parser.
-- Optional: jq/xmllint/prettier/stylua response formatters; Node for request scripts; grpcurl/websocat/openssl for those protocols.
-- require("extras.util.rest")

-- Dependencies: Neovim 0.12.6; Git for vim.pack; vim-startuptime; nvim executable.
-- require("extras.util.startuptime")

-- General Prettier formatting: before Markdown; select it OR Biome/Oxfmt for shared filetypes.
-- Dependencies: node; prettier (npm prettier); framework-specific Prettier plugins in the project when needed.
-- require("extras.formatting.prettier")

-- TypeScript: wrapper uses vtsls; replace its internal call to choose native tsc.
-- Dependencies: node; vtsls (npm @vtsls/language-server); typescript (npm typescript); optional js-debug-adapter wrapper + tsx/ts-node (npm packages) for DAP.
-- Parsers (install manually): javascript, typescript, tsx.
-- require("extras.lang.typescript")

-- Dependencies: node; vtsls (npm @vtsls/language-server); typescript (npm typescript).
-- Parsers (install manually): javascript, typescript, tsx.
-- require("extras.lang.typescript.vtsls")

-- Dependencies: tsc >=7.0 (native TypeScript compiler, npm typescript >=7); older TypeScript releases lack --lsp.
-- Parsers (install manually): javascript, typescript, tsx.
-- require("extras.lang.typescript.tsc")

-- Dependencies: biome (npm @biomejs/biome).
-- require("extras.lang.typescript.biome")

-- Dependencies: oxlint + oxfmt (npm packages oxlint and oxfmt).
-- require("extras.lang.typescript.oxc")

-- Optional languages: TypeScript above must precede its Angular/Astro/Svelte/Vue integrations.
-- Dependencies: node; ngserver (npm @angular/language-server); project npm packages typescript + @angular/language-server for vtsls integration.
-- Parsers (install manually): angular, scss.
-- require("extras.lang.angular")

-- Dependencies: node; ansible-language-server (npm @ansible/ansible-language-server); Python; ansible-playbook (pip ansible-core); ansible-lint (pip ansible-lint).
-- Plugins: mfussenegger/nvim-ansible (https://github.com/mfussenegger/nvim-ansible).
-- Parsers (install manually): yaml.
-- require("extras.lang.ansible")

-- Dependencies: node; astro-ls (npm @astrojs/language-server); project npm packages typescript + @astrojs/ts-plugin for vtsls integration.
-- Parsers (install manually): astro, css.
-- require("extras.lang.astro")

-- Dependencies: clangd + clang-format (LLVM); optional codelldb (CodeLLDB release) for extras.dap.core.
-- Plugins: p00f/clangd_extensions.nvim; https://github.com/p00f/clangd_extensions.nvim
-- Parsers (install manually): c, cpp, cuda.
-- require("extras.lang.clangd")

-- Dependencies: clojure + a project nREPL (Clojure CLI / Leiningen); optional clojure-lsp if uncommented below.
-- Plugins: Olical/conjure, julienvincent/nvim-paredit, m00qek/baleia.nvim, PaterJason/cmp-conjure, blink.compat v2.
-- Parsers (install manually): clojure.
-- require("extras.lang.clojure")

-- Dependencies: neocmakelsp (neocmakelsp release); cmake; cmake-format (pip cmakelang); cmakelint (pip cmakelint).
-- Plugins: Civitasv/cmake-tools.nvim + plenary.nvim; https://github.com/Civitasv/cmake-tools.nvim
-- Parsers (install manually): cmake.
-- require("extras.lang.cmake")

-- Dependencies: dart (Dart SDK; https://dart.dev/get-dart).
-- Parsers (install manually): dart.
-- require("extras.lang.dart")

-- Dependencies: node; docker-langserver (npm package dockerfile-language-server-nodejs); docker-compose-langserver (npm package @microsoft/compose-language-service); hadolint (hadolint release).
-- Parsers (install manually): dockerfile.
-- require("extras.lang.docker")

-- Dependencies: dotnet (SDK); OmniSharp (OmniSharp release on PATH); fsautocomplete (dotnet tool); csharpier, fantomas (dotnet tools); optional netcoredbg (release).
-- Plugins: Hoffs/omnisharp-extended-lsp.nvim; https://github.com/Hoffs/omnisharp-extended-lsp.nvim
-- Parsers (install manually): c_sharp, fsharp.
-- require("extras.lang.dotnet")

-- Dependencies: elixir + mix; elixir-ls (ElixirLS release wrapper on PATH); optional credo (project mix dependency).
-- Parsers (install manually): elixir, heex, eex, markdown.
-- require("extras.lang.elixir")

-- Dependencies: node; elm, elm-test, elm-format, elm-language-server (npm packages elm, elm-test, elm-format, @elm-tooling/elm-language-server).
-- Parsers (install manually): elm.
-- require("extras.lang.elm")

-- Dependencies: node; ember-language-server (npm @ember-tooling/ember-language-server); prettier (npm prettier) if formatting is enabled.
-- Parsers (install manually): css, glimmer, glimmer_javascript, glimmer_typescript.
-- require("extras.lang.ember")

-- Dependencies: erl + erlang_ls (erlang_ls release; https://erlang-ls.github.io/getting-started/).
-- Parsers (install manually): erlang.
-- require("extras.lang.erlang")

-- Dependencies: git, curl; optional gh (GitHub CLI) / glab (GitLab CLI) for issue completion.
-- Plugins: petertriho/cmp-git (native Blink source); https://github.com/petertriho/cmp-git
-- Parsers (install manually): git_config, gitcommit, git_rebase, gitignore, gitattributes.
-- require("extras.lang.git")

-- Dependencies: gleam (Gleam toolchain; https://gleam.run/getting-started/installing/).
-- Parsers (install manually): gleam.
-- require("extras.lang.gleam")

-- Dependencies: go; gopls, goimports, gofumpt (Go packages); golangci-lint (release); optional dlv (Delve) for debugging.
-- Plugins: optional leoluz/nvim-dap-go; https://github.com/leoluz/nvim-dap-go
-- Parsers (install manually): go, gomod, gowork, gosum.
-- require("extras.lang.go")

-- Dependencies: ghc, cabal or stack; haskell-language-server-wrapper (GHCup); fourmolu, cabal-fmt, hlint (Haskell packages); optional hoogle/haskell-debugger.
-- Plugins: mrcjkb/haskell-tools.nvim v10; https://github.com/mrcjkb/haskell-tools.nvim
-- Parsers (install manually): haskell.
-- require("extras.lang.haskell")

-- Dependencies: helm_ls (helm-ls release; https://github.com/mrjosh/helm-ls); yaml-language-server (npm yaml-language-server); helm for CLI commands.
-- Plugins: qvalentin/helm-ls.nvim; https://github.com/qvalentin/helm-ls.nvim
-- Parsers (install manually): helm.
-- require("extras.lang.helm")

-- Dependencies: java >=21; python3 >=3.9 for jdtls wrapper; jdtls (Eclipse JDT LS release executable on PATH); optional prebuilt java-debug/vscode-java-test JARs.
-- Plugins: mfussenegger/nvim-jdtls; https://github.com/mfussenegger/nvim-jdtls
-- Parsers (install manually): java.
-- require("extras.lang.java")

-- Dependencies: node; vscode-json-language-server (npm vscode-langservers-extracted).
-- Plugins: b0o/SchemaStore.nvim; https://github.com/b0o/SchemaStore.nvim
-- Parsers (install manually): json, jsonc, json5.
-- require("extras.lang.json")

-- Dependencies: julia; Julia packages LanguageServer and SymbolServer (install with Julia Pkg).
-- Plugins: kdheepak/cmp-latex-symbols + saghen/blink.compat v2 (Blink v1).
-- Parser (install manually): julia.
-- require("extras.lang.julia")

-- Dependencies: java (JDK); kotlin-language-server (fwcd release); ktlint (release); optional kotlin-debug-adapter (fwcd release).
-- Parsers (install manually): kotlin.
-- require("extras.lang.kotlin")

-- Dependencies: lean + lake from a manually installed Lean toolchain (elan); see https://lean-lang.org/lean4/doc/quickstart.html.
-- Plugins: Julian/lean.nvim; https://github.com/Julian/lean.nvim
-- Parsers (install manually): lean.
-- require("extras.lang.lean")

-- Dependencies: marksman (release); node; prettier, markdownlint-cli2, markdown-toc (npm packages); optional node/yarn for manually prepared browser preview.
-- Plugins: iamcco/markdown-preview.nvim + MeanderingProgrammer/render-markdown.nvim.
-- Parsers (install manually): markdown, markdown_inline.
-- require("extras.lang.markdown")

-- Dependencies: nil (nil language server), nixfmt, statix (Nix packages nil, nixfmt, statix).
-- Parsers (install manually): nix.
-- require("extras.lang.nix")

-- Dependencies: nu (Nushell; https://www.nushell.sh/book/installation.html).
-- Parsers (install manually): nu.
-- require("extras.lang.nushell")

-- Dependencies: ocamllsp (opam package ocaml-lsp-server; https://github.com/ocaml/ocaml-lsp).
-- Parsers (install manually): ocaml.
-- require("extras.lang.ocaml")

-- Dependencies: PHP; phpactor (Composer phpactor/phpactor); phpcs (Composer squizlabs/php_codesniffer); php-cs-fixer (Composer friendsofphp/php-cs-fixer); optional php-debug-adapter.
-- Parsers (install manually): php.
-- require("extras.lang.php")

-- Dependencies: node; prisma-language-server (npm package @prisma/language-server).
-- Parsers (install manually): prisma.
-- require("extras.lang.prisma")

-- Dependencies: python3; pyright-langserver (npm pyright, needs node); ruff (pip/uv ruff); fd for venv discovery; optional debugpy-adapter (pip debugpy).
-- Plugins: linux-cultist/venv-selector.nvim; optional mfussenegger/nvim-dap-python; https://github.com/linux-cultist/venv-selector.nvim
-- Parsers (install manually): python, ninja, rst.
-- require("extras.lang.python")

-- Dependencies: R; R package languageserver (manual install.packages("languageserver")).
-- Parsers (install manually): r, rnoweb, csv, markdown, markdown_inline, latex, yaml.
-- require("extras.lang.r")

-- Dependencies: regols (Rego language server) and regal (Regal CLI; https://github.com/open-policy-agent/regal).
-- Parsers (install manually): rego.
-- require("extras.lang.rego")

-- Dependencies: ruby; ruby-lsp, rubocop, erb-formatter (Ruby gems); optional solargraph or standard; optional rdbg (debug gem) for DAP.
-- Plugins: optional suketa/nvim-dap-ruby; https://github.com/suketa/nvim-dap-ruby
-- Parsers (install manually): ruby.
-- require("extras.lang.ruby")

-- Dependencies: rustc + cargo; rust-analyzer (rustup component add rust-analyzer); optional codelldb (CodeLLDB release); optional bacon/bacon-ls for alternate diagnostics.
-- Plugins: mrcjkb/rustaceanvim, Saecki/crates.nvim, plenary.nvim; https://github.com/mrcjkb/rustaceanvim
-- Parsers (install manually): rust, ron, toml.
-- require("extras.lang.rust")

-- Dependencies: java (JDK); metals (manually installed launcher, e.g. cs install metals); Scala project build tools as required.
-- Plugins: scalameta/nvim-metals + plenary.nvim; https://github.com/scalameta/nvim-metals
-- Parsers (install manually): scala.
-- require("extras.lang.scala")

-- Dependencies: node; vscode-solidity-server (npm package vscode-solidity-server); forge (Foundry) for formatting.
-- Parsers (install manually): solidity.
-- require("extras.lang.solidity")

-- Dependencies: SQL client for your DB (psql/mysql/sqlite3/sqlcmd/etc.); sqlfluff (pip/uv sqlfluff); configure your database connection manually.
-- Plugins: tpope/vim-dadbod, kristijanhusak/vim-dadbod-ui, kristijanhusak/vim-dadbod-completion.
-- Parsers (install manually): sql.
-- require("extras.lang.sql")

-- Dependencies: node; svelteserver (npm svelte-language-server); project npm packages typescript + typescript-svelte-plugin for vtsls integration.
-- Parsers (install manually): svelte.
-- require("extras.lang.svelte")

-- Dependencies: node; tailwindcss-language-server (npm @tailwindcss/language-server).
-- require("extras.lang.tailwind")

-- Dependencies: terraform (HashiCorp CLI); terraform-ls (HashiCorp language server); packer for HCL formatting.
-- Parsers (install manually): terraform, hcl.
-- require("extras.lang.terraform")

-- Dependencies: texlab (release); TeX distribution with latexmk; PDF viewer supporting SyncTeX (Skim/Zathura/SumatraPDF); optional pplatex.
-- Plugins: lervag/vimtex; https://github.com/lervag/vimtex
-- Parsers (install manually): bibtex, latex.
-- require("extras.lang.tex")

-- Dependencies: thriftls (binary from joyme123/thrift-ls releases; https://github.com/joyme123/thrift-ls/releases).
-- Parsers (install manually): thrift.
-- require("extras.lang.thrift")

-- Dependencies: taplo (Taplo CLI; https://taplo.tamasfe.dev/cli/installation.html).
-- Parsers (install manually): toml.
-- require("extras.lang.toml")

-- Dependencies: node; twiggy-language-server (npm package twiggy-language-server); PHP; twigcs (Composer friendsoftwig/twigcs); twig-cs-fixer (Composer vincentlanglet/twig-cs-fixer).
-- Parsers (install manually): twig.
-- require("extras.lang.twig")

-- Dependencies: tinymist (release); typstyle (release); websocat (release) for preview; typst for standalone CLI compilation.
-- Plugins: chomosuke/typst-preview.nvim; optional folke/ts-comments.nvim.
-- Parsers (install manually): typst.
-- require("extras.lang.typst")

-- Dependencies: node; vue-language-server (npm @vue/language-server); project npm packages typescript + @vue/typescript-plugin for vtsls integration.
-- Parsers (install manually): vue, css.
-- require("extras.lang.vue")

-- Dependencies: node; yaml-language-server (npm yaml-language-server).
-- Plugins: b0o/SchemaStore.nvim; https://github.com/b0o/SchemaStore.nvim
-- Parsers (install manually): yaml.
-- require("extras.lang.yaml")

-- Dependencies: zig; zls (Zig language server; https://github.com/zigtools/zls).
-- Parsers (install manually): zig.
-- require("extras.lang.zig")

-- Python Black formatting: after Python, replaces its Ruff formatter.
-- Dependencies: python3; black (pip install black or uv tool install black).
-- require("extras.formatting.black")

-- ESLint diagnostics/actions and explicit save fixes; keep one separate JS/TS formatter.
-- Dependencies: node; vscode-eslint-language-server (npm vscode-langservers-extracted); eslint (project npm eslint).
-- require("extras.linting.eslint")

-- VS Code: use the early explicit branch documented in this module.
-- Dependencies: Neovim 0.12.6; Git for vim.pack; VS Code with vscode-neovim extension and its supplied `vscode` Lua module; no plugin dependency added here.
-- require("extras.vscode")
