-- Dependencies: conform.nvim (configured by plugins/formatting.lua).
-- External formatter commands are listed in that module and the enabled language modules.
-- Docs: https://github.com/stevearc/conform.nvim#api
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
local M = {}

--- Return whether automatic formatting is enabled for this buffer.
--- A buffer override takes precedence over the global setting.
--- Unset settings mean enabled; nil or 0 selects the current buffer.
---@param buf? integer
---@return boolean
function M.enabled(buf)
  buf = buf or 0
  local enabled = vim.b[buf].autoformat
  if enabled == nil then
    enabled = vim.g.autoformat
  end
  return enabled ~= false
end

--- Toggle automatic formatting and report the new setting in a notification.
--- nil toggles the global setting; a buffer number sets a local override.
--- Use 0 for the current buffer. A global toggle preserves buffer overrides.
---@param buf? integer
function M.toggle(buf)
  if buf == nil then
    vim.g.autoformat = not (vim.g.autoformat ~= false)
    vim.notify("Autoformat (global): " .. (vim.g.autoformat and "on" or "off"))
  else
    vim.b[buf].autoformat = not M.enabled(buf)
    vim.notify("Autoformat (buffer): " .. (vim.b[buf].autoformat and "on" or "off"))
  end
end

--- Format through Conform, targeting the current buffer unless opts overrides it.
--- This explicit request runs regardless of the automatic-formatting setting.
---@param opts? conform.FormatOpts
function M.format(opts)
  return require("conform").format(vim.tbl_extend("force", { bufnr = 0 }, opts or {}))
end

return M
