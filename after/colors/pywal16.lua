vim.cmd.source(vim.fn.stdpath("data") .. "/lazy/pywal16.nvim/colors/pywal16.vim")
local c = require("pywal16.core").get_colors()
local function adjust_hex(hex, percent)
  hex = hex:gsub("#", "")
  local function clamp(v)
    return math.max(0, math.min(255, v))
  end

  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)

  local f = percent / 100
  r = clamp(r + (255 - r) * f)
  g = clamp(g + (255 - g) * f)
  b = clamp(b + (255 - b) * f)

  return string.format("#%02x%02x%02x", r, g, b)
end

local function is_dark_fast(hex)
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)

  -- 简单平均亮度
  local avg = (r + g + b) / 3
  return avg < 128
end

vim.api.nvim_set_hl(0, "PmenuSel", { bg = c.color4, fg = c.background })
if is_dark_fast(c.color0) then
  vim.api.nvim_set_hl(0, "CursorLine", { bg = adjust_hex(c.color0, 12) })
  vim.api.nvim_set_hl(0, "CursorColumn", { bg = adjust_hex(c.color0, 8) })
else
  vim.api.nvim_set_hl(0, "CursorLine", { bg = adjust_hex(c.color0, -10) })
  vim.api.nvim_set_hl(0, "CursorColumn", { bg = adjust_hex(c.color0, -5) })
end
