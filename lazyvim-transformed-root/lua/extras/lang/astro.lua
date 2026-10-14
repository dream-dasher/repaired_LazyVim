-- Dependencies: node; astro-ls (npm @astrojs/language-server); project npm packages typescript + @astrojs/ts-plugin for vtsls integration.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink), plugins.formatting (conform.nvim).
-- Parsers (install manually): astro, css.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Enable extras.lang.typescript (vtsls) BEFORE this module. The native tsc alternative does not support this tsserver plugin.
-- Plugin location is project node_modules; edit location below or set NVIM_ASTRO_TS_PLUGIN to an absolute package directory.
-- Server definition: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/astro.lua
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Extend vtsls initialization for Astro while keeping earlier integrations.
local previous_before_init = vim.lsp.config.vtsls.before_init
vim.lsp.config("vtsls", {
  -- Add the Astro tsserver plugin before each TypeScript client initializes.
  before_init = function(params, config)
    if previous_before_init then
      previous_before_init(params, config)
    end
    -- Edit this location for global/custom npm layouts; default is project-local.
    local location = vim.env.NVIM_ASTRO_TS_PLUGIN
      or vim.fs.joinpath(config.root_dir or vim.fn.getcwd(), "node_modules", "@astrojs/ts-plugin")
    -- Append to existing tsserver plugins so framework extras can coexist.
    local settings = config.settings.vtsls
    settings.tsserver = settings.tsserver or {}
    settings.tsserver.globalPlugins = settings.tsserver.globalPlugins or {}
    table.insert(settings.tsserver.globalPlugins, {
      name = "@astrojs/ts-plugin",
      location = location,
      enableForWorkspaceTypeScriptVersions = true,
    })
  end,
})
-- Enable Astro-specific language support alongside the TypeScript client.
vim.lsp.config("astro", {})
vim.lsp.enable("astro")
-- Enable with extras.formatting.prettier if Prettier owns formatting:
-- require("conform").formatters_by_ft.astro = { "prettier" }
