local M = {}

-- Get the path to the config dir
--_G.CONFIG_DIR = vim.api.nvim_list_runtime_paths()[1]
_G.CONFIG_DIR = vim.fn.stdpath("config")
_G.DATA_DIR = vim.fn.stdpath("data")
-- Function to source vimscript files
function M.source_viml(file)
  vim.cmd("source " .. CONFIG_DIR .. "/" .. file)
end

-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
function M.extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
  end
  return config
end

---@param func function The function to get source code from
function M.func_source(func)
  local info = debug.getinfo(func, "S")
  if info.source:sub(1, 1) == "@" then
    local file_path = info.source:sub(2)
    local file = io.open(file_path, "r")
    if file then
      local lines = {}
      for line in file:lines() do
        table.insert(lines, line)
      end
      file:close()
      local start_line = info.linedefined
      local end_line = info.lastlinedefined
      local source = {}
      for i = start_line, end_line do
        table.insert(source, lines[i])
      end
      return table.concat(source, "\n")
    end
  end
end

-- @param obj The object to inspect
-- @return string The string representation of the object
function M.obj_inspect(obj)
  if type(obj) == "function" then
    local info = debug.getinfo(obj, "S")
    local fun_str = string.format("<%s:%d>", info.short_src, info.linedefined)
    fun_str = fun_str
      .. "\n┌┄┄┄┄┄SOURCE CODE BEGIN┄┄┄┄┄\n┊"
      .. M.func_source(obj):gsub("\n", "\n┊")
      .. "\n└┄┄┄┄┄┄SOURCE CODE END┄┄┄┄┄┄"
    return fun_str
  elseif type(obj) == "table" then
    local result = {}
    for k, v in pairs(obj) do
      if type(k) == "number" then
        -- If key is number, add [ ] to it
        k = "[" .. k .. "]"
      elseif type(k) == "string" and k:find("[^%w]") then
        -- If key contains special characters, add [" "] to it
        k = string.format('["%s"]', k)
      end
      local str_v = M.obj_inspect(v)
      -- replace \n with \n\t
      str_v = str_v:gsub("\n", "\n\t")
      table.insert(result, string.format("\t%s = %s", k, str_v))
    end
    local content = table.concat(result, ",\n")
    if content == "" then
      return "{}"
    end
    return "{\n" .. content .. "\n}"
  else
    return vim.inspect(obj)
  end
end

-- A function to print lua tables. It's useful for debugging
-- @param ... The objects to print
-- @return ... The objects
function M.obj_dump(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, M.obj_inspect(v))
  end
  local res = table.concat(objects, "\n")
  vim.notify(res, vim.log.levels.INFO)
  return ...
end

function M.sl()
  vim.api.nvim_command("write")
  local config_dir = vim.fn.stdpath("config")
  dofile(config_dir .. "/init.lua")
end

function M.safe_require(module_name)
  local status, module = pcall(require, module_name)
  if not status then
    vim.notify(module_name .. " not found!")
    return nil
  end
  return module
end

function M.encode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

--local first_visible_line = vim.fn.line("w0") -- 获取当前窗口的第一个可见行
--local last_visible_line = vim.fn.line("w$") -- 获取当前窗口的最后一个可见行
--local last_line = vim.fn.line("$") -- 获取缓冲区中的最后一行
--vim.o.scrolloff -- 获取当前的scrolloff值
--vim.api.nvim_win_get_cursor(0)[1]

function M.scroll_viewport(lines)
  local f_last_line = vim.fn.line("$") -- 获取文件的最后一行(绝对)
  local w_first_line = vim.fn.line("w0") -- 获取当前窗口的第一个可见行(绝对)
  --local w_last_line = vim.fn.line("w$") -- 获取当前窗口的最后一个可见行
  local w_height = vim.fn.winheight(0) -- 获取当前窗口的高度 (行数, 仅内容)
  local c_height = vim.fn.winline() -- cursor所在高度(相对)
  local scrolloff = vim.o.scrolloff -- 获取当前的scrolloff值
  if lines > 0 then
    -- Check if we can scroll down (至少要有一个可见行, 即滚动后viewport第一行不超过文件最后一行)
    if w_first_line + lines > f_last_line then
      lines = f_last_line - w_first_line
    end
    -- 不要把cursor弹开, 保持cursor
    if c_height - lines < scrolloff then
      lines = c_height - scrolloff
    end
    if lines > 0 then
      vim.cmd(M.encode("normal! " .. lines .. "<C-e>"))
    end
  elseif lines < 0 then
    -- Check if we can scroll up
    if w_first_line + lines < 1 then
      lines = 1 - w_first_line
    end
    -- Do not push the cursor off the screen
    if w_height - c_height - lines < scrolloff then
      lines = w_height - c_height - scrolloff
    end
    if lines < 0 then
      vim.cmd(M.encode("normal! " .. math.abs(lines) .. "<C-y>"))
    end
  end
end

----------------------Color Utils----------------------

---@class RGB Handle RGB colors
---@field r number The red component (0-255)
---@field g number The green component (0-255)
---@field b number The blue component (0-255)
---@field is_rgb fun(): boolean Whether the object is an RGB object
---@field to_hex fun(): string Converts the RGB color to a hexadecimal string
---@field to_xyz fun(): table Converts the RGB color to a CIE 1931 XYZ color
---@field mix fun(other: RGB, t: number): RGB Mixes the color with another color
---@field from_hex fun(hex: string): RGB Converts a hexadecimal color string to an RGB object
---@field from_xyz fun(xyz: table): RGB Converts a CIE 1931 XYZ color to an RGB color
---@field from_lab fun(lab: table): RGB Converts a CIE L*a*b* color to an RGB color
---@field to_lab fun(): table Converts the RGB color to a CIE L*a*b* color
local RGB = {}
M.RGB = RGB
RGB.__index = RGB
RGB.__type = "RGB"

--- Creates a new RGB object.
-- @param r The red component (0-255).
-- @param g The green component (0-255).
-- @param b The blue component (0-255).
-- @return A new RGB object.
function RGB:new(r, g, b)
  local obj = {
    r = math.min(math.max(r, 0), 255),
    g = math.min(math.max(g, 0), 255),
    b = math.min(math.max(b, 0), 255),
  }
  setmetatable(obj, self)
  return obj
end

function RGB:__eq(other)
  return self.r == other.r and self.g == other.g and self.b == other.b
end

-- 判断是否是RGB对象的方法
function RGB:is_rgb()
  return self.__type == "RGB"
end

--- Converts the RGB color to a hexadecimal string.
-- @return A string representing the color in hexadecimal format, e.g., "#ff0000".
function RGB:to_hex()
  return string.format("#%02x%02x%02x", self.r, self.g, self.b)
end

--- Converts a hexadecimal color string to an RGB object.
-- @param hex A string representing the color in hexadecimal format, e.g., "#ff0000".
-- @return An RGB object representing the color.
function RGB.from_hex(hex)
  hex = hex:gsub("#", "")
  return RGB:new(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
end

local function rgb_to_xyz(rgb)
  local r = rgb.r / 255
  local g = rgb.g / 255
  local b = rgb.b / 255

  r = r > 0.04045 and ((r + 0.055) / 1.055) ^ 2.4 or r / 12.92
  g = g > 0.04045 and ((g + 0.055) / 1.055) ^ 2.4 or g / 12.92
  b = b > 0.04045 and ((b + 0.055) / 1.055) ^ 2.4 or b / 12.92

  r = r * 100
  g = g * 100
  b = b * 100

  local x = r * 0.4124 + g * 0.3576 + b * 0.1805
  local y = r * 0.2126 + g * 0.7152 + b * 0.0722
  local z = r * 0.0193 + g * 0.1192 + b * 0.9505

  return { x = x, y = y, z = z }
end

-- 转换 RGB 到 XYZ
function RGB:to_xyz()
  return rgb_to_xyz(self)
end

-- 从 XYZ 转换为 RGB
function RGB.from_xyz(xyz)
  local x = xyz.x / 100
  local y = xyz.y / 100
  local z = xyz.z / 100

  local r = x * 3.2406 + y * -1.5372 + z * -0.4986
  local g = x * -0.9689 + y * 1.8758 + z * 0.0415
  local b = x * 0.0557 + y * -0.2040 + z * 1.0570

  local function gamma_correction(channel)
    return channel > 0.0031308 and 1.055 * (channel ^ (1 / 2.4)) - 0.055 or channel * 12.92
  end

  r = gamma_correction(r) * 255
  g = gamma_correction(g) * 255
  b = gamma_correction(b) * 255

  return RGB:new(r, g, b)
end

local function lab_to_rgb(lab)
  -- Lab 转 XYZ
  local y = (lab.l + 16) / 116
  local x = lab.a / 500 + y
  local z = y - lab.b / 200

  local delta = 6 / 29
  local function f(t)
    return t > delta and t ^ 3 or (t - 16 / 116) / 7.787
  end

  x = 95.047 * f(x)
  y = 100.000 * f(y)
  z = 108.883 * f(z)

  -- XYZ 转 RGB
  return RGB.from_xyz({ x = x, y = y, z = z })
end

-- 从 Lab 转换为 RGB
function RGB.from_lab(lab)
  lab_to_rgb(lab)
end

local function rgb_to_lab(rgb)
  local xyz = rgb_to_xyz(rgb)
  local x = xyz.x / 95.047
  local y = xyz.y / 100.000
  local z = xyz.z / 108.883

  local function f(t)
    return t > 0.008856 and t ^ (1 / 3) or (7.787 * t) + (16 / 116)
  end

  x = f(x)
  y = f(y)
  z = f(z)

  local l = (116 * y) - 16
  local a = 500 * (x - y)
  local b = 200 * (y - z)

  return { l = l, a = a, b = b }
end

-- 转换 RGB 到 Lab
function RGB:to_lab()
  return rgb_to_lab(self)
end

-- 混合两个 RGB 对象
function RGB:mix(other, t)
  local lab1 = self:to_lab()
  local lab2 = other:to_lab()
  local mixed_lab = {
    l = lab1.l * (1 - t) + lab2.l * t,
    a = lab1.a * (1 - t) + lab2.a * t,
    b = lab1.b * (1 - t) + lab2.b * t,
  }
  return RGB.from_lab(mixed_lab)
end

function M.get_highlight_hex(group, type)
  type = type or "fg"
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  if hl[type] == nil then
    return #000000
  end
  return string.format("#%x", hl[type])
end

-- Function to get the RGB color of a highlight group
function M.get_highlight_rgb(group, type)
  type = type or "fg" -- Default to 'fg' (foreground) if no type is provided
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  if hl[type] == nil then
    return { r = 0, g = 0, b = 0 } -- Return black if the highlight type is not defined
  end
  local rgb = RGB:new(
    bit.rshift(bit.band(hl[type], 0xFF0000), 16), -- Extract the red component
    bit.rshift(bit.band(hl[type], 0x00FF00), 8), -- Extract the green component
    bit.band(hl[type], 0x0000FF) -- Extract the blue component
  )
  return rgb
end

-- Function to convert various inputs to an RGB color
function M.any_to_rgb(color)
  -- If input is already an RGB table, return it
  if type(color) == "table" and color.r and color.g and color.b then
    return RGB:new(color.r, color.g, color.b)
  elseif type(color) == "string" then
    -- If input is a hex string, convert it to RGB
    if color:sub(1, 1) == "#" then
      return RGB.from_hex(color)
    end
    -- If input is a highlight group, get its RGB value
    return M.get_highlight_rgb(color)
  end
end

-- Function to mix two colors
-- @param color1 The first color (in RGB table format)
-- @param color2 The second color (in RGB table format)
-- @param opt Options:
-- @param opt.ratio The ratio for mixing the two colors (optional, default is 0.5)
-- @param opt.ret The return type, "rgb" or "hex" (optional, default is "rgb")
-- @return The mixed color in the format specified by opt.ret
function M.mix_colors_in_rgb(color1, color2, ratio)
  color1 = M.any_to_rgb(color1) -- Convert the first color to RGB format
  color2 = M.any_to_rgb(color2) -- Convert the second color to RGB format
  ratio = ratio or 0.5 -- Default mixing ratio is 0.5 (equal parts)
  local rgb = RGB:new( -- Create a new RGB object with the mixed
    math.floor(color1.r * ratio + color2.r * (1 - ratio)), -- Mix red components
    math.floor(color1.g * ratio + color2.g * (1 - ratio)), -- Mix green components
    math.floor(color1.b * ratio + color2.b * (1 - ratio)) -- Mix blue components
  )
  return rgb
end

-- Function to convert an RGB table to a hex string
function M.rgb_to_hex(color)
  if not M.check_rgb(color) then
    vim.notify("Invalid RGB color: " .. M.obj_inspect(color), vim.log.levels.ERROR)
    return nil
  end
  return string.format("#%02x%02x%02x", color.r, color.g, color.b) -- Format as hex
end

-- Function to check if a string is a valid hex color
function M.check_hex(hex)
  return hex:sub(1, 1) == "#" and #hex == 7 -- Must start with '#' and be 7 characters long
end

-- Function to check if a table is a valid RGB color
function M.check_rgb(rgb)
  local flag = type(rgb) == "table" and rgb.r and rgb.g and rgb.b
  flag = flag and type(rgb.r) == "number" and rgb.r >= 0 and rgb.r <= 255
  flag = flag and type(rgb.g) == "number" and rgb.g >= 0 and rgb.g <= 255
  flag = flag and type(rgb.b) == "number" and rgb.b >= 0 and rgb.b <= 255
  return flag -- Return true if all RGB values are valid
end

-- Function to convert a hex string to an RGB table
function M.hex_to_rgb(hex)
  -- Ensure the hex string is valid
  if not M.check_hex(hex) then
    vim.notify("Invalid hex color: " .. hex, vim.log.levels.ERROR)
    return nil
  end
  hex = hex:gsub("#", "") -- Remove the '#' character
  return RGB:new( -- Create a new RGB table with the hex values
    tonumber(hex:sub(1, 2), 16), -- Extract and convert red component
    tonumber(hex:sub(3, 4), 16), -- Extract and convert green component
    tonumber(hex:sub(5, 6), 16) -- Extract and convert blue component
  )
end

function M.color_difference_in_lab(color1, color2)
  color1, color2 = M.any_to_rgb(color1), M.any_to_rgb(color2)
  local lab1 = rgb_to_lab(color1)
  local lab2 = rgb_to_lab(color2)
  return math.sqrt((lab1.l - lab2.l) ^ 2 + (lab1.a - lab2.a) ^ 2 + (lab1.b - lab2.b) ^ 2)
end

function M.generate_distinct_color_in_lab(background_color, threshold)
  background_color = M.any_to_rgb(background_color)
  local function random_color()
    return { r = math.random(0, 255), g = math.random(0, 255), b = math.random(0, 255) }
  end
  local color
  repeat
    color = random_color()
  until M.color_difference_in_lab(background_color, color) > threshold
  return color
end

local function find_furthest_lab(lab)
  -- 假设 Lab 空间的对角线从 (0, 0, 0) 到 (100, 128, 128)
  local opposite_color_lab = {
    l = 100 - lab.l,
    a = 128 - lab.a,
    b = 128 - lab.b,
  }
  return opposite_color_lab
end

function M.get_contrast_color_in_lab(color)
  color = M.any_to_rgb(color)
  return lab_to_rgb(find_furthest_lab(color))
end

-- 混合两个 Lab 颜色
local function mix_lab(lab1, lab2, t)
  return {
    l = lab1.l * (1 - t) + lab2.l * t,
    a = lab1.a * (1 - t) + lab2.a * t,
    b = lab1.b * (1 - t) + lab2.b * t,
  }
end

-- 主要函数，用于混合两个 RGB 颜色
function M.mix_colors_in_lab(color1, color2, t)
  color1 = M.any_to_rgb(color1)
  color2 = M.any_to_rgb(color2)
  t = t or 0.5
  -- 将 RGB 转换为 Lab
  local color1_lab = rgb_to_lab(color1)
  local color2_lab = rgb_to_lab(color2)

  -- 混合 Lab 颜色
  local mixed_lab = mix_lab(color1_lab, color2_lab, t)

  -- 将混合后的 Lab 颜色转换回 RGB
  return lab_to_rgb(mixed_lab)
end

return M
