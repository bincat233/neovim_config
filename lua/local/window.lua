local M = {}

function M.encode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

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
