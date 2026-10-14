# Changes from LazyVim

The standalone config preserves LazyVim's default plugin choices while making the setup order and configuration local to ordinary Lua files. The original source is retained outside this directory for comparison. Optional modules document their own dependencies and required direct edits.

## Framework machinery removed

Removed lazy.nvim and its bootstrap, plugin registry, import priorities, spec and option merging, automatic module loading, and default/user configuration overlays. Removed `lazyvim.json`, migration logic, recommended-extra discovery, `LazyExtras`, news handling, and framework import-order checks. There is no global `LazyVim` object or replacement compatibility manager.

`<leader>l` and `<leader>L` are unassigned. Removed the dashboard's Lazy manager and extras entries, `<leader>sp` plugin-spec search, Lazy update counts, and Lazy-specific statusline extensions. Ordinary lowercase `l` and uppercase `L` retain Neovim's normal editing behavior.

Project-root discovery remains a small explicit helper: the deepest containing LSP workspace, then the nearest `.git`, `.jj`, or `lua` marker, then the current working directory. It has no configuration registry, detector selection, or cache invalidation layer. The formatting helper retains global and buffer `autoformat` toggles; Conform owns format-on-save with LSP fallback directly.

## Lazy loading dropped

| Original trigger or mechanism | Standalone behavior |
| --- | --- |
| `VeryLazy` for keymaps, autocmds, UI, mini plugins, Flash, and WhichKey | Explicit startup calls |
| `LazyFile`, `BufReadPre`, and `BufNewFile` for syntax, Git, lint, and LSP plugin loading | Plugins available at startup; normal per-buffer behavior keeps ordinary events |
| `InsertEnter` and `CmdlineEnter` for Blink | Blink configured at startup |
| Command and key handlers that load Conform, Trouble, search/replace, or session plugins | Plugins configured at startup; mappings invoke their normal APIs |
| Filetype-triggered loading of optional language plugins | Enabled modules load at startup; server attachment and filetype mappings retain normal `FileType`/LSP events |
| `optional`, `enabled`, `cond`, `specs`, `opts_extend`, and nested dependency spec patches | Ordinary Lua calls, commented alternatives, and documented direct edits |
| Theme priority and lazy theme selection | Explicit colorscheme call, after icons and before UI setup |
| Automatically inferred optional integrations and import order | Explicit plugin setup and documented ordering in `init.lua` |

No lazy loading shim is provided. Upstream plugins may defer their own rendering or buffer behavior; that does not introduce another configuration layer.

## Installation and build changes

Removed Mason, mason-lspconfig, Mason Treesitter CLI installation, Mason debugging installation, and package-path lookup. Servers, tools, adapter binaries, and application credentials must be installed and configured manually. Native LSP reads server definitions from nvim-lspconfig and starts their declared commands from `PATH`.

Removed automatic Tree-sitter parser installation and update hooks. `:TSInstall` and `:TSUpdate` remain manual download and compilation commands. Extras list their parser names in comments. Removed plugin-manager build hooks; native sorters, LuaSnip's optional jsregexp component, Avante, Markdown preview, and provider tools have explicit manual instructions where needed.

Blink uses native snippets and Lua fuzzy matching, with prebuilt binary downloads disabled. Removed LazyVim's private native-snippet repair code and cross-provider AI acceptance arbitration. Native snippets handle the supported Neovim syntax directly; snippets that depend on VSCode transforms or repaired repeated defaults may need editing or the documented LuaSnip alternative.

R's default optional module uses the native R language server. R.nvim remains a commented example because its setup can build/install helper components automatically. Rust is enabled with LazyVim's original automatic Cargo checks, build-script evaluation, and procedural macros; these can run project code and write build output when editing Rust. Metals disables automatic build import, and Haskell Tools disables automatic fast-tags generation.

Kulala is pinned to the verified Lua-based v5.3.4 release. Its setup normally prepares a parser automatically, so this module checks that the parser is already prepared and refuses setup until the documented manual step is complete. This avoids introducing the different backend used by newer releases.

Erlang LS was removed from current nvim-lspconfig and its upstream is archived. The optional Erlang module preserves the original server with a complete native command, filetype, and root-marker definition; its header links to ELP as a possible replacement.

## Alternative plugins and interactions

Most alternatives share mappings or UI responsibilities. Read the module header before uncommenting its call; commenting a module after installation does not delete its native package checkout.

| Area | Choose or adjust directly |
| --- | --- |
| Completion | Blink or nvim-cmp; changing to nvim-cmp also changes the capability call in `plugins/lsp.lua` |
| Snippets | Native snippets, LuaSnip, or mini.snippets; load alternatives before Blink and set its `snippets.preset` |
| Picker | Snacks, fzf-lua, or Telescope; disable the replaced Snacks picker and adjust picker-backed mappings as documented |
| Explorer | Snacks, Neo-tree, or mini.files; disable the replaced Snacks explorer and replace shared explorer maps |
| Motion and highlighting | Flash versus Leap; Snacks words versus illuminate |
| Git signs | Gitsigns versus mini.diff; their signs and hunk maps overlap |
| Dashboard | Snacks versus Alpha, dashboard-nvim, or mini.starter |
| Indentation and scrolling | Snacks indent/scope versus indent-blankline/mini.indentscope; Snacks scroll versus mini.animate |
| Cursor animation | mini.animate cursor animation versus smear-cursor |
| Symbol outline | Trouble symbols, Aerial, Outline, or Navic/lualine integrations; several use `<leader>cs` |
| AI completion | Native Copilot versus copilot.lua; decide provider mappings and Blink sources directly |
| TypeScript | vtsls or the tsc alternative; avoid simultaneous ts_ls/vtsls/TypeScript-owned clients |
| Python | pyright or basedpyright; use Ruff's native server rather than also enabling ruff_lsp; Ruff hover yields to the type checker |
| Ruby | Solargraph's Rubocop integration can duplicate a separate Rubocop LSP client's diagnostics |
| Formatting | Conform, none-ls, Biome, Prettier, Oxfmt, and ESLint need explicit ownership per filetype; later optional assignments replace earlier ones |
| Language-owned LSP | Java/jdtls, Rustaceanvim, Haskell Tools, Lean, and Metals own their startup; do not also enable a second generic client |
| Test adapters | Add the desired plugin URL and adapter directly to `extras/test/core.lua`; language modules include examples |

Specialized framework injections into dashboards, statuslines, completion providers, or other extras become direct configuration examples instead of automatically rewriting another plugin's setup. This makes enabling an integration an inspectable local edit.

Go's optional none-ls code actions, language-specific Neotest adapters, Terraform's Telescope extensions, Haskell snippets, SQL panes in Edgy, and symbol/statusline integrations include direct-edit examples in their module headers. Old fabricated Go semantic-token capabilities and nvim-cmp-only language sorting/colorizer patches are omitted from the Blink defaults. The VS Code module supplies native editor actions and documents an early explicit branch that avoids loading terminal UI modules.
