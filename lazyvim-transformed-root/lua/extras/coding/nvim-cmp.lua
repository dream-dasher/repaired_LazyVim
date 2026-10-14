-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-cmp; cmp-nvim-lsp; cmp-buffer; cmp-path; no external executable.
-- Docs: https://github.com/hrsh7th/nvim-cmp
-- Enable: require("extras.coding.nvim-cmp") in init.lua.
-- REPLACE require("plugins.blink") with this call, BEFORE require("plugins.lsp").
-- In plugins/lsp.lua remove Blink's capabilities call; this module sets native global LSP capabilities.
-- Conflicts: never enable with Blink. Snippet expansion uses vim.snippet; edit expand below for another engine.
-- Dropped: framework completion action chaining, automatic brackets, AI/statusline option injection.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load the completion engine and its LSP, path, and buffer sources.
vim.pack.add({
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
})
local cmp = require("cmp")
-- Advertise completion capabilities to native LSP clients configured after this module.
vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
-- Give completion ghost text a default highlight that colorschemes may override.
vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
-- Configure the menu, native snippet expansion, mappings, and source priority together.
cmp.setup({
  snippet = {
    -- Expand the LSP snippet body using Neovim's built-in snippet engine.
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  completion = { completeopt = "menu,menuone,noinsert" },
  preselect = cmp.PreselectMode.Item,
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- Jump to the next snippet field when possible; otherwise delegate to the normal key.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    -- Jump to the previous snippet field when possible; otherwise delegate to the normal key.
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "path" }, { name = "buffer" } }),
  formatting = {
    -- Prefix the completion kind with its configured icon and return the modified item.
    format = function(_, item)
      item.kind = (require("config.icons").kinds[item.kind] or "") .. " " .. item.kind
      return item
    end,
  },
  experimental = { ghost_text = { hl_group = "CmpGhostText" } },
})
