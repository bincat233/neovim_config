local utils = require("ccc.utils")
local parse = require("ccc.utils.parse")
local pattern = require("ccc.utils.pattern")

---@class ccc.ColorPicker.Gtk: ccc.ColorPicker
---@field pattern string[]
local GtkPicker = {}
local rgb = {}
local min_length = 0
local color_table = { white = "#FFFFFF" }

function GtkPicker:init()
  ---@type { plain: string, vim: string }[]
  local patterns = {}
  for name, rgb_str in pairs(color_table) do
    -- Match #RRGGBB or rgb(RR, GG, BB) or rgba(RR, GG, BB, AA)
    local r, g, b = rgb_str:match("(%x%x)(%x%x)(%x%x)")
    -- Try to match the rgb() or rgba() format.
    if not (r and g and b) then
      r, g, b = rgb_str:match("rgba*%((%d+),%s*(%d+),%s*(%d+)")
      local nr = tonumber(r)
      local ng = tonumber(g)
      local nb = tonumber(b)
      if not nr or not ng or not nb or nr < 0 or nr > 255 or ng < 0 or ng > 255 or nb < 0 or nb > 255 then
        goto continue
      end
      r = string.format("%02X", tonumber(nr))
      g = string.format("%02X", tonumber(ng))
      b = string.format("%02X", tonumber(nb))
    end
    if not (r and g and b) then
      goto continue
    end
    local escaped = name:gsub([[\]], "%0%0")
    table.insert(patterns, { plain = name, vim = escaped })
    rgb[name] = { parse.hex(r), parse.hex(g), parse.hex(b) }
    ::continue::
  end
  if #patterns == 0 then
    return
  end
  -- Sort names to match the longest “word” at first.
  -- If more than one branch matches, the first one is used.
  -- Since keys are not guaranteed to be in 'iskeyword',
  -- we should order them from the longest to the shortest.
  table.sort(patterns, function(a, b)
    return #a.plain > #b.plain
  end)
  min_length = #patterns[#patterns].plain
  local vim_patterns = vim.tbl_map(function(v)
    return v.vim
  end, patterns)
  self.pattern = [[\V\<\%(]] .. table.concat(vim_patterns, [[\|]]) .. [[\)\>]]
  --vim.notify_once(self.pattern, vim.log.levels.INFO)
end

---@param s string
---@param init? integer
---@return integer? start_col
---@return integer? end_col
---@return RGB? rgb
---@return Alpha? alpha
function GtkPicker:parse_color(s, init)
  -- First find if there are any color define in this line.
  local new_name, new_color = string.match(s, "@define%-color%s+([%w-_]+)%s+([^;]+);")
  if new_name and new_color then
    --vim.notify_once("[ccc] new color: " .. new_name .. " " .. new_color, vim.log.levels.INFO)
    color_table[new_name] = new_color
  end

  -- Parser for GTK CSS color names.
  if vim.tbl_isempty(color_table) then
    vim.notify_once("[ccc] no entries for the GTK CSS picker", vim.log.levels.WARN)
    return
  end
  self:init()
  init = vim.F.if_nil(init, 1) --[[@as integer]]
  if #s - init + 1 < min_length then
    return
  end
  local start_col, end_col = pattern.find(s, self.pattern, init)
  if start_col and end_col then
    local name = s:sub(start_col, end_col)
    local rgb_value = rgb[name]
    if rgb_value then
      return start_col, end_col, rgb_value
    end
  end
end

return GtkPicker
