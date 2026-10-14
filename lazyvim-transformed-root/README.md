# Standalone Neovim configuration

This directory is a complete Neovim 0.12.6 configuration derived from LazyVim 16.0.1. It retains the default editor plugins, Blink completion, Snacks picker and explorer, and nvim-lspconfig's server definitions. Native `vim.pack` installs plugins; native LSP APIs configure and enable servers. Edit the files directly to customize the editor.

## Configuration order

Read `init.lua` first. Its ordered `require` calls are the entire configuration entry point. Every module lists its plugin and executable dependencies at the top, with a shorter reminder beside its call in `init.lua`.

The local `stylua.toml` disables require sorting so formatting preserves this startup order.

`lua/config/` contains options, mappings, autocmds, and icon data. `lua/plugins/` configures the default plugins. `lua/extras/` contains optional configurations and alternatives. `lua/util/` contains small project-root and formatting helpers. `queries/lua/highlights.scm` extends native Lua highlighting to recognize `vim` as a builtin namespace.

There is no plugin selection UI, spec merging, default/user override hierarchy, or plugin registry. To disable something, comment its call or remove its setup and mappings. To enable an extra, uncomment its call, install the listed external tools, and make any direct edits described in its header. Some alternatives must replace an existing frontend or change a default plugin's options; see [MIGRATION.md](MIGRATION.md).

## External tools

Install these yourself; this configuration does not install language servers, formatters, linters, or debugging adapters.

| Tool | Purpose |
| --- | --- |
| Neovim 0.12.6 or newer | Native package management, LSP, snippets, diagnostics, and Tree-sitter APIs |
| `git` | Plugin installation and Git features |
| `rg` | Grep, search and replace, TODO search, and file-finding fallback |
| `fd` | Recommended file finder; optional features may require it explicitly |
| `lua-language-server` | Default Lua LSP server |
| `stylua` | Default Lua formatter |
| `shfmt` | Formatter for shell buffers |
| `fish`, including `fish_indent` | Fish linting and formatting |
| `curl`, `tar`, a C compiler, `tree-sitter` CLI 0.26.1+ | Manual Tree-sitter parser installation; install the CLI with a system package manager rather than npm |
| Nerd Font and a clipboard provider | Recommended glyphs and system clipboard integration |
| `lazygit`, `gh` | Optional terminal Git UI and authenticated GitHub pickers |

Each enabled language module documents its additional tools and manual parser command. Ordinary language-server behavior can run project checks or subprocesses after attachment; language modules flag noteworthy build behavior. Optional debugger and test commands run your project's programs when invoked.

## Trying the configuration

To keep a trial's plugin installs, lockfile, undo files, caches, and sessions within this repository, run from the repository root:

```sh
mkdir -p no-sync/try/{config,data,state,cache}
XDG_CONFIG_HOME="$PWD/no-sync/try/config" \
XDG_DATA_HOME="$PWD/no-sync/try/data" \
XDG_STATE_HOME="$PWD/no-sync/try/state" \
XDG_CACHE_HOME="$PWD/no-sync/try/cache" \
NVIM_LOG_FILE="$PWD/no-sync/try/nvim.log" \
nvim -u "$PWD/lazyvim-transformed-root/init.lua"
```

**The first launch downloads the enabled plugins after native installation confirmation.** No plugin build hooks or parser installers run automatically. Parser-dependent features become available after you install the relevant parsers. Saving files, formatting, and running tools still act on the files you open; the environment isolation above concerns Neovim's own storage.

For normal use, put the contents of this directory in your Neovim configuration directory after preserving your existing configuration. `-u` alone changes the entry file, but does not isolate Neovim's standard data, config, state, or cache directories. Config-file pickers use `stdpath('config')`, so during the trial they show the isolated config directory.

## Plugin installation and updates

Each plugin module calls `vim.pack.add()` with explicit repository URLs. Configuration runs eagerly in the order shown by `init.lua`; normal LSP attachment, filetype behavior, and plugin UI events remain event driven.

Native package management writes `nvim-pack-lock.json` in the standard configuration directory. Keep that generated file with the deployed configuration for reproducible revisions. It records all managed plugins; disabling an optional module does not remove its checkout or its lockfile entry. Remove plugins explicitly through the native API when desired.

```vim
:lua vim.pack.update()
```

Review the native update buffer. `:write` accepts the changes and `:quit` discards them. Restart Neovim afterwards. After updating nvim-treesitter, also run `:TSUpdate` yourself. That command downloads and compiles parsers; review its requirements before running it. There are no replacement mappings for the removed Lazy manager keys.

Blink uses its released 1.x API and Lua fuzzy matching, with binary downloads disabled. This avoids a Rust build or downloaded native matcher; matcher scoring and performance may differ from Blink's Rust implementation.

## Parser installation

The default parser list is documented beside `plugins.treesitter` in `init.lua` and at the top of that module. For example:

```vim
:TSInstall lua luadoc luap vim vimdoc query
:TSInstall markdown markdown_inline
```

These are explicit network and compiler operations. Missing parsers leave native syntax and indentation available rather than starting an installer. Queries describe how a syntax tree supplies highlights, folds, indentation, text objects, and language injections; the config's Lua query extends the installed highlight queries.

## Validation

The default configuration was started with Neovim 0.12.6 against read-only, already installed plugin sources. The verification redirected standard config, data, state, cache, and log paths into ignored `no-sync/`, substituted package installation, and prevented external LSP processes from starting. It exercised actual plugin setup, Lua filetype handling, native LSP configuration and Blink capabilities, and the absence of Lazy management mappings. All Lua modules are checked for syntax.

Focused checks also cover containing-workspace boundaries (including `/`), global versus buffer autoformat overrides, per-buffer lint debouncing, folding state when switching between LSP and Tree-sitter buffers in the same window, and the missing-parser guard that prevents Kulala setup from starting a build. Another isolated check resolves 27 optional configuration modules through native server definitions without launching their commands.

Native first-install confirmation is checked with a status-column redraw before Snacks exists and installation declined. The startup check also renders the column before each plugin addition and verifies that Snacks enables its renderer after setup.

This verifies configuration against those installed plugin versions. Optional plugins, external language servers, debug adapters, project test runners, parser compilation, and fresh network installations require their documented dependencies and have not all been run. See [MIGRATION.md](MIGRATION.md) for behavioral changes and conflicts.

## Sources and license

The configuration is derived from [LazyVim](https://github.com/LazyVim/LazyVim), licensed under Apache 2.0. The original source remains alongside this directory for comparison. A copy of the original license is included here. Primary API references: [native packages](https://neovim.io/doc/user/pack/), [native LSP](https://neovim.io/doc/user/lsp/), [nvim-treesitter main](https://github.com/nvim-treesitter/nvim-treesitter/tree/main), and [Conform](https://github.com/stevearc/conform.nvim).
