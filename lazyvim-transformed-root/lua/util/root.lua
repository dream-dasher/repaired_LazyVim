-- Dependencies: Neovim >= 0.12.6; no external tools or plugins.
-- Docs: https://neovim.io/doc/user/lua/#vim.fs.root()
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).
local M = {}

local function normalize(path)
  return vim.fs.normalize(vim.uv.fs_realpath(path) or path)
end

---@param buf? integer
---@return string
function M.get(buf)
  if buf == nil or buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end
  local name = vim.api.nvim_buf_get_name(buf)
  local path = name ~= "" and normalize(name) or normalize(vim.uv.cwd() or ".")
  local roots = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if client.name ~= "copilot" then
      local candidates = { client.root_dir or client.config.root_dir }
      for _, workspace in ipairs(client.workspace_folders or client.config.workspace_folders or {}) do
        candidates[#candidates + 1] = vim.uri_to_fname(workspace.uri)
      end
      for _, candidate in ipairs(candidates) do
        if type(candidate) == "string" then
          candidate = normalize(candidate)
          -- Match a directory boundary: /work/app must not match /work/apple.
          local prefix = candidate:sub(-1) == "/" and candidate or candidate .. "/"
          if path == candidate or path:sub(1, #prefix) == prefix then
            roots[#roots + 1] = candidate
          end
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  return roots[1] or vim.fs.root(path, { ".git", ".jj", "lua" }) or normalize(vim.uv.cwd() or ".")
end

---@param buf? integer
---@return string
function M.git(buf)
  return vim.fs.root(M.get(buf), ".git") or M.get(buf)
end

return M
