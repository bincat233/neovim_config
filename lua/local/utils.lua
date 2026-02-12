local M = {}

local color = require("local.color")
local debug_utils = require("local.debug")
local window = require("local.window")

M.CONFIG_DIR = vim.fn.stdpath("config")
M.DATA_DIR = vim.fn.stdpath("data")

function M.source_viml(file)
  vim.cmd("source " .. M.CONFIG_DIR .. "/" .. file)
end

---@param config table
---@param custom function|table|nil
function M.extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom)
  end
  return config
end

function M.sl()
  vim.api.nvim_command("write")
  dofile(M.CONFIG_DIR .. "/init.lua")
end

function M.safe_require(module_name)
  local ok, module = pcall(require, module_name)
  if not ok then
    vim.notify(module_name .. " not found!")
    return nil
  end
  return module
end

local function merge(dst, src)
  for k, v in pairs(src) do
    dst[k] = v
  end
end

merge(M, debug_utils)
merge(M, color)
merge(M, window)

return M
