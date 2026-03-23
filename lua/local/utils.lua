local M = {}

M.CONFIG_DIR = vim.fn.stdpath("config")
M.DATA_DIR = vim.fn.stdpath("data")

---@param file string Relative path under config directory.
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

---@param module_name string
---@return any|nil
function M.safe_require(module_name)
  local ok, module = pcall(require, module_name)
  if not ok then
    vim.notify(module_name .. " not found!")
    return nil
  end
  return module
end

local cached_env = nil

---Detect current running environment once and cache the result.
---@return "windows"|"macos"|"linux_wayland"|"linux_x11"|"linux_ssh"|"linux_console"
function M.get_env()
  if cached_env ~= nil then
    return cached_env
  end

  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    cached_env = "windows"
  elseif vim.fn.has("macunix") == 1 then
    cached_env = "macos"
  elseif os.getenv("WAYLAND_DISPLAY") then
    cached_env = "linux_wayland"
  elseif os.getenv("DISPLAY") then
    cached_env = "linux_x11"
  elseif os.getenv("SSH_TTY") then
    cached_env = "linux_ssh"
  else
    cached_env = "linux_console"
  end

  return cached_env
end

---@param str string
---@return string
function M.encode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

---Scroll viewport while respecting file/window boundaries and scrolloff.
---@param lines integer Positive scrolls down, negative scrolls up.
function M.scroll_viewport(lines)
  local file_last_line = vim.fn.line("$")
  local window_first_line = vim.fn.line("w0")
  local window_height = vim.fn.winheight(0)
  local cursor_height = vim.fn.winline()
  local scrolloff = vim.o.scrolloff

  if lines > 0 then
    if window_first_line + lines > file_last_line then
      lines = file_last_line - window_first_line
    end

    if cursor_height - lines < scrolloff then
      lines = cursor_height - scrolloff
    end

    if lines > 0 then
      vim.cmd(M.encode("normal! " .. lines .. "<C-e>"))
    end
  elseif lines < 0 then
    if window_first_line + lines < 1 then
      lines = 1 - window_first_line
    end

    if window_height - cursor_height - lines < scrolloff then
      lines = window_height - cursor_height - scrolloff
    end

    if lines < 0 then
      vim.cmd(M.encode("normal! " .. math.abs(lines) .. "<C-y>"))
    end
  end
end

return M
