-- Dependencies: node; vue-language-server (npm @vue/language-server); project npm packages typescript + @vue/typescript-plugin for vtsls integration.
-- Config modules: plugins.lsp (nvim-lspconfig + Blink).
-- Parsers (install manually): vue, css.
-- LSP definitions / executable details: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt
-- Parser installation: https://github.com/nvim-treesitter/nvim-treesitter#installation
-- Enable extras.lang.typescript (vtsls) BEFORE this module. The native tsc alternative does not support this tsserver plugin.
-- Plugin location is project node_modules; edit location below or set NVIM_VUE_TS_PLUGIN to an absolute package directory.
-- Server definition: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/vue_ls.lua
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Extend vtsls initialization for Vue while retaining earlier framework hooks.
local previous_before_init = vim.lsp.config.vtsls.before_init
vim.lsp.config("vtsls", {
  -- Add Vue's tsserver plugin before each TypeScript client initializes.
  before_init = function(params, config)
    if previous_before_init then
      previous_before_init(params, config)
    end
    -- Edit this location for global/custom npm layouts; default is project-local.
    local location = vim.env.NVIM_VUE_TS_PLUGIN
      or vim.fs.joinpath(config.root_dir or vim.fn.getcwd(), "node_modules", "@vue/typescript-plugin")
    -- Append to the plugin list rather than replacing existing integrations.
    local settings = config.settings.vtsls
    settings.tsserver = settings.tsserver or {}
    settings.tsserver.globalPlugins = settings.tsserver.globalPlugins or {}
    table.insert(settings.tsserver.globalPlugins, {
      name = "@vue/typescript-plugin",
      location = location,
      languages = { "vue" },
      configNamespace = "typescript",
      enableForWorkspaceTypeScriptVersions = true,
    })
  end,
})
-- Include Vue buffers in vtsls attachment without modifying the original list.
local filetypes = vim.deepcopy(vim.lsp.config.vtsls.filetypes)
if not vim.tbl_contains(filetypes, "vue") then
  filetypes[#filetypes + 1] = "vue"
end
vim.lsp.config("vtsls", { filetypes = filetypes })
-- Also enable Vue's dedicated server for Vue-specific language features.
vim.lsp.config("vue_ls", {})
vim.lsp.enable("vue_ls")
