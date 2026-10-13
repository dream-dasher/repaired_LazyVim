-- Dependencies: conform.nvim (configured by plugins/formatting.lua).
-- External formatter commands are listed in that module and the enabled language modules.
-- Docs: https://github.com/stevearc/conform.nvim#api
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
local M = {}

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

-- No buffer means a global toggle; 0 means the current buffer's override.
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

---@param opts? conform.FormatOpts
function M.format(opts)
  return require("conform").format(vim.tbl_extend("force", { bufnr = 0 }, opts or {}))
end

return M
