local M = {}

local bitlib = bit or bit32

---@class RGB
---@field r number
---@field g number
---@field b number
local RGB = {}
M.RGB = RGB
RGB.__index = RGB
RGB.__type = "RGB"

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

function RGB:is_rgb()
  return self.__type == "RGB"
end

function RGB:to_hex()
  return string.format("#%02x%02x%02x", self.r, self.g, self.b)
end

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

function RGB:to_xyz()
  return rgb_to_xyz(self)
end

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
  local y = (lab.l + 16) / 116
  local x = lab.a / 500 + y
  local z = y - lab.b / 200

  local delta = 6 / 29
  local function f(t)
    return t > delta and t ^ 3 or (t - 16 / 116) / 7.787
  end

  x = 95.047 * f(x)
  y = 100.0 * f(y)
  z = 108.883 * f(z)

  return RGB.from_xyz({ x = x, y = y, z = z })
end

function RGB.from_lab(lab)
  return lab_to_rgb(lab)
end

local function rgb_to_lab(rgb)
  local xyz = rgb_to_xyz(rgb)
  local x = xyz.x / 95.047
  local y = xyz.y / 100.0
  local z = xyz.z / 108.883

  local function f(t)
    return t > 0.008856 and t ^ (1 / 3) or (7.787 * t) + (16 / 116)
  end

  x = f(x)
  y = f(y)
  z = f(z)

  return {
    l = (116 * y) - 16,
    a = 500 * (x - y),
    b = 200 * (y - z),
  }
end

function RGB:to_lab()
  return rgb_to_lab(self)
end

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
    return "#000000"
  end
  return string.format("#%06x", hl[type])
end

local function split_rgb(value)
  if bitlib then
    return bitlib.rshift(bitlib.band(value, 0xFF0000), 16), bitlib.rshift(bitlib.band(value, 0x00FF00), 8), bitlib.band(value, 0x0000FF)
  end

  local r = math.floor(value / 0x10000) % 0x100
  local g = math.floor(value / 0x100) % 0x100
  local b = value % 0x100
  return r, g, b
end

function M.get_highlight_rgb(group, type)
  type = type or "fg"
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  if hl[type] == nil then
    return RGB:new(0, 0, 0)
  end

  local r, g, b = split_rgb(hl[type])
  return RGB:new(r, g, b)
end

function M.any_to_rgb(color)
  if type(color) == "table" and color.r and color.g and color.b then
    return RGB:new(color.r, color.g, color.b)
  end

  if type(color) == "string" then
    if color:sub(1, 1) == "#" then
      return RGB.from_hex(color)
    end
    return M.get_highlight_rgb(color)
  end

  return nil
end

function M.mix_colors_in_rgb(color1, color2, ratio)
  color1 = M.any_to_rgb(color1)
  color2 = M.any_to_rgb(color2)
  ratio = ratio or 0.5

  return RGB:new(
    math.floor(color1.r * ratio + color2.r * (1 - ratio)),
    math.floor(color1.g * ratio + color2.g * (1 - ratio)),
    math.floor(color1.b * ratio + color2.b * (1 - ratio))
  )
end

function M.check_hex(hex)
  return hex:sub(1, 1) == "#" and #hex == 7
end

function M.check_rgb(rgb)
  local flag = type(rgb) == "table" and rgb.r and rgb.g and rgb.b
  flag = flag and type(rgb.r) == "number" and rgb.r >= 0 and rgb.r <= 255
  flag = flag and type(rgb.g) == "number" and rgb.g >= 0 and rgb.g <= 255
  flag = flag and type(rgb.b) == "number" and rgb.b >= 0 and rgb.b <= 255
  return flag
end

function M.rgb_to_hex(color)
  if not M.check_rgb(color) then
    vim.notify("Invalid RGB color: " .. vim.inspect(color), vim.log.levels.ERROR)
    return nil
  end
  return string.format("#%02x%02x%02x", color.r, color.g, color.b)
end

function M.hex_to_rgb(hex)
  if not M.check_hex(hex) then
    vim.notify("Invalid hex color: " .. hex, vim.log.levels.ERROR)
    return nil
  end

  hex = hex:gsub("#", "")
  return RGB:new(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
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
  return {
    l = 100 - lab.l,
    a = 128 - lab.a,
    b = 128 - lab.b,
  }
end

function M.get_contrast_color_in_lab(color)
  color = M.any_to_rgb(color)
  local lab = rgb_to_lab(color)
  return lab_to_rgb(find_furthest_lab(lab))
end

local function mix_lab(lab1, lab2, t)
  return {
    l = lab1.l * (1 - t) + lab2.l * t,
    a = lab1.a * (1 - t) + lab2.a * t,
    b = lab1.b * (1 - t) + lab2.b * t,
  }
end

function M.mix_colors_in_lab(color1, color2, t)
  color1 = M.any_to_rgb(color1)
  color2 = M.any_to_rgb(color2)
  t = t or 0.5

  local color1_lab = rgb_to_lab(color1)
  local color2_lab = rgb_to_lab(color2)
  local mixed_lab = mix_lab(color1_lab, color2_lab, t)
  return lab_to_rgb(mixed_lab)
end

return M
