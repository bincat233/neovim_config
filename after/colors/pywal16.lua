local theme_path = vim.fn.stdpath("data") .. "/lazy/pywal16.nvim/colors/pywal16.vim"

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

local function apply_pywal16_overrides()
  local ok, core = pcall(require, "pywal16.core")
  if not ok then
    return
  end

  local c = core.get_colors()
  if not c or not c.color0 or not c.color4 or not c.background then
    return
  end

  vim.g.colors_name = "pywal16"

  vim.api.nvim_set_hl(0, "PmenuSel", { bg = c.color4, fg = c.background })
  if is_dark_fast(c.color0) then
    vim.api.nvim_set_hl(0, "CursorLine", { bg = adjust_hex(c.color0, 12) })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = adjust_hex(c.color0, 8) })
  else
    vim.api.nvim_set_hl(0, "CursorLine", { bg = adjust_hex(c.color0, -10) })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = adjust_hex(c.color0, -5) })
  end
end

local function reload_base_pywal16()
  if vim.fn.filereadable(theme_path) ~= 1 then
    return false
  end
  vim.g.colors_name = nil
  local ok = pcall(vim.cmd.source, theme_path)
  if ok then
    vim.g.colors_name = "pywal16"
  end
  return ok
end

local function hard_reload_pywal16()
  if vim.g._pywal16_reloading then
    return
  end

  vim.g._pywal16_reloading = true
  --local was_bg = vim.o.background
  pcall(vim.cmd.colorscheme, "default")
  pcall(vim.cmd.colorscheme, "pywal16")
  --vim.o.background = was_bg
  apply_pywal16_overrides()
  vim.g._pywal16_reloading = false
end

local group = vim.api.nvim_create_augroup("Pywal16AfterColors", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  pattern = "pywal16",
  callback = apply_pywal16_overrides,
})

vim.api.nvim_create_autocmd("OptionSet", {
  group = group,
  pattern = "background",
  callback = function()
    if vim.g._pywal16_reloading then
      return
    end
    if vim.g.colors_name ~= "pywal16" then
      return
    end
    vim.notify("Background changed, reloading pywal16...", vim.log.levels.INFO)
    vim.schedule(hard_reload_pywal16)
  end,
})

vim.api.nvim_create_user_command("Pywal16ApplyOverrides", apply_pywal16_overrides, {})
vim.api.nvim_create_user_command("Pywal16ReloadBase", reload_base_pywal16, {})
vim.api.nvim_create_user_command("Pywal16Reload", hard_reload_pywal16, {})

reload_base_pywal16()
apply_pywal16_overrides()
