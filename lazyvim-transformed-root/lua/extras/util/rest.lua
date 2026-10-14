-- Dependencies: Neovim 0.12.6; Git for vim.pack; Kulala v5.3.4; curl; manually installed kulala_http parser.
-- Optional: jq/xmllint/prettier/stylua response formatters; Node for request scripts; grpcurl/websocat/openssl for those protocols.
-- Docs: https://github.com/dont-be-evil-company/kulala.nvim/tree/v5.3.4
-- Enable: require("extras.util.rest") in init.lua.
-- Pinned to the Lua implementation; newer 6.x releases use a different external backend.
-- Manual parser preparation: review v5.3.4's lua/kulala/config/parser.lua first; then invoke
-- :lua require("kulala.config.parser").set_kulala_parser()
-- That EXPLICIT command compiles/installs the parser and writes its version cache. Restart Neovim afterward.
-- Alternatively compile that checkout's tree-sitter/src/parser.c and install parser/queries manually.
-- Setup has no upstream disable-install option; the preflight below refuses setup when a build would be attempted.
-- HTTP requests and embedded scripts run ONLY on user invocation and may modify remote/local resources. Review request scripts first.
-- No compiler or parser-install command is invoked from this module.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Recognize .http buffers and load the reviewed Lua-based Kulala release.
vim.filetype.add({ extension = { http = "http" } })
vim.pack.add({ { src = "https://github.com/dont-be-evil-company/kulala.nvim", version = "v5.3.4" } })
-- Stop before Kulala setup if the existing parser cannot be loaded, preventing automatic compilation.
local parser_ok, parser_loaded = pcall(vim.treesitter.language.add, "kulala_http")
if not parser_ok or not parser_loaded then
  vim.notify(
    "Prepare Kulala's parser manually as documented in extras/util/rest.lua, then restart.",
    vim.log.levels.WARN
  )
  return
end
-- Upstream checks these locations before it trusts a parser prepared by nvim-treesitter.
local directories = { vim.fs.joinpath(vim.fn.stdpath("data"), "site", "parser") }
local ok, old_ts = pcall(require, "nvim-treesitter.configs")
if ok and old_ts.get_parser_install_dir then
  local dir = old_ts.get_parser_install_dir()
  if dir then
    directories[#directories + 1] = dir
  end
end
-- Compare Kulala's bundled parser version with the previously recorded installation version.
local fs = require("kulala.utils.fs")
local metadata = fs.read_json(fs.get_plugin_path({ "..", "tree-sitter" }) .. "/tree-sitter.json")
local expected = metadata and metadata.metadata and metadata.metadata.version
local recorded = require("kulala.db").settings.parser_ver
-- Stop if an installed parser would trigger upstream's version-based rebuild on setup.
for _, directory in ipairs(directories) do
  for _, extension in ipairs({ "so", "dylib", "dll" }) do
    if vim.uv.fs_stat(directory .. "/kulala_http." .. extension) and recorded ~= expected then
      vim.notify(
        "Kulala parser version needs manual preparation; see extras/util/rest.lua, then restart.",
        vim.log.levels.WARN
      )
      return
    end
  end
end
-- Initialize only after the parser preflight, then expose scratchpad and replay actions.
local kulala = require("kulala")
kulala.setup({})
vim.keymap.set("n", "<leader>Rb", function()
  kulala.scratchpad()
end, { desc = "HTTP scratchpad" })
vim.keymap.set("n", "<leader>Rr", function()
  kulala.replay()
end, { desc = "Replay HTTP request" })
-- Add request/environment/navigation actions only to HTTP buffers when their filetype is assigned.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function(event)
    for key, method in pairs({
      Rc = "copy",
      RC = "from_curl",
      Re = "set_selected_env",
      Rg = "download_graphql_schema",
      Ri = "inspect",
      Rn = "jump_next",
      Rp = "jump_prev",
      Rq = "close",
      Rs = "run",
      RS = "show_stats",
      Rt = "toggle_view",
    }) do
      vim.keymap.set("n", "<leader>" .. key, function()
        kulala[method]()
      end, { buffer = event.buf, desc = "HTTP: " .. method })
    end
  end,
})
