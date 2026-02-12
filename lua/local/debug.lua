local M = {}

---@param func function
---@return string|nil
function M.func_source(func)
  local info = debug.getinfo(func, "S")
  if not info or info.source:sub(1, 1) ~= "@" then
    return nil
  end

  local file_path = info.source:sub(2)
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end

  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()

  local source = {}
  for i = info.linedefined, info.lastlinedefined do
    table.insert(source, lines[i] or "")
  end
  return table.concat(source, "\n")
end

---@param obj any
---@return string
function M.obj_inspect(obj)
  if type(obj) == "function" then
    local info = debug.getinfo(obj, "S")
    local source = M.func_source(obj) or "<source unavailable>"
    return string.format("<%s:%d>\nSOURCE BEGIN\n%s\nSOURCE END", info.short_src, info.linedefined, source)
  end

  if type(obj) == "table" then
    local result = {}
    for k, v in pairs(obj) do
      if type(k) == "number" then
        k = "[" .. k .. "]"
      elseif type(k) == "string" and k:find("[^%w]") then
        k = string.format('["%s"]', k)
      end

      local str_v = M.obj_inspect(v):gsub("\n", "\n\t")
      table.insert(result, string.format("\t%s = %s", k, str_v))
    end

    local content = table.concat(result, ",\n")
    if content == "" then
      return "{}"
    end
    return "{\n" .. content .. "\n}"
  end

  return vim.inspect(obj)
end

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

return M
