-- SDCC support for clangd.
--
-- The dialect shim follows the community compatibility-header approach while
-- avoiding legacy unprefixed macros that collide with ordinary C identifiers.
local M = {}

local cache = {}

local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local contents = file:read("*a")
  file:close()
  return contents
end

local function target_from_text(text)
  for token in text:gmatch("%S+") do
    local normalized = token:gsub("^[\"']", ""):gsub("([,\"'\\\\])+$", "")
    local target = normalized:match("^%-m([%w%d_]+)$")
    if target then
      return target
    end
  end
end

local function inspect_build_files(root)
  local result = { detected = false, target = nil }
  local marker = vim.fs.joinpath(root, ".sdcc")
  if vim.uv.fs_stat(marker) then
    result.detected = true
    local marker_text = read_file(marker) or ""
    result.target = marker_text:match("target%s*=%s*([%w%d_]+)")
  end

  for _, name in ipairs({ "Makefile", "makefile", "GNUmakefile", "compile_commands.json" }) do
    local text = read_file(vim.fs.joinpath(root, name))
    if text and text:lower():find("sdcc", 1, true) then
      result.detected = true
      result.target = result.target or target_from_text(text)
    end
  end
  return result
end

function M.project(root)
  if not root then
    return { detected = false }
  end
  root = vim.fs.normalize(root)
  if not cache[root] then
    cache[root] = inspect_build_files(root)
  end
  return cache[root]
end

local function search_dirs(sdcc, target)
  local result = vim.system({ sdcc, "-m" .. target, "--print-search-dirs" }, { text = true }):wait()
  if result.code ~= 0 then
    return nil, result.stderr
  end

  local dirs, in_includes = {}, false
  for line in result.stdout:gmatch("[^\r\n]+") do
    if line == "includedir:" then
      in_includes = true
    elseif line:match("^[%a]+dir:") or line == "libpath:" then
      in_includes = false
    elseif in_includes and vim.uv.fs_stat(line) then
      local normalized = vim.fs.normalize(line)
      if not vim.tbl_contains(dirs, normalized) then
        table.insert(dirs, normalized)
      end
    end
  end
  return dirs
end

function M.fallback_flags(root)
  local project = M.project(root)
  if not project.detected then
    return nil
  end

  local sdcc = vim.fn.exepath("sdcc")
  if sdcc == "" then
    return nil, "SDCC executable not found"
  end

  local target = project.target or "mcs51"
  local dirs, err = search_dirs(sdcc, target)
  if not dirs then
    return nil, err
  end

  local shim = vim.fs.joinpath(vim.fn.stdpath("config"), "include", "sdcc_clangd.h")
  if not vim.uv.fs_stat(shim) then
    return nil, "clangd compatibility header not found: " .. shim
  end
  local flags = { "-xc", "-std=c11", "-ffreestanding", "-include", shim }

  for _, dir in ipairs(dirs) do
    vim.list_extend(flags, { "-isystem", dir })
  end
  for _, name in ipairs({ "include", "inc" }) do
    local dir = vim.fs.joinpath(root, name)
    if vim.uv.fs_stat(dir) then
      vim.list_extend(flags, { "-I", dir })
    end
  end
  return flags, nil, target
end

return M
