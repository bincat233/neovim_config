-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufReadPost" }, {
--  pattern = vim.fn.expand("$HOME") .. "/.config/sway/**/*.conf",
--  command = "set filetype=swayconfig",
--})

--- creates an auto group
local function augroup(autocmd, name)
  name = name or "end"
  vim.api.nvim_exec2("augroup " .. name .. " \nautocmd!\n" .. autocmd .. "\naugroup end", {})
end

--- makes neovim support hex editing
local function binary_editor()
  -- file extensions to treat as binaries
  local ft = "*.bin,*.out,*.png"

  augroup([[
    au BufReadPre  ]] .. ft .. [[ let &bin=1
    au BufReadPost ]] .. ft .. [[ if &bin | %!xxd
    au BufReadPost ]] .. ft .. [[ set ft=xxd | endif
    au BufWritePre ]] .. ft .. [[ if &bin | %!xxd -r
    au BufWritePre ]] .. ft .. [[ endif
    au BufWritePost ]] .. ft .. [[ if &bin | %!xxd
    au BufWritePost ]] .. ft .. [[ set nomod | endif
  ]], "binary_edit")
end

binary_editor()

-- WORKAROUND: chezmoi.vim 的 use_tmp_buffer 检测方式在 nvim 0.13+ 下失效，
-- 导致 dot_zshrc 等无扩展名的 chezmoi 源文件被识别为 `conf` 而非正确类型。
-- 等 chezmoi.vim 修复 nvim 0.13 兼容性后可移除此段。
-- 相关 issue: https://github.com/alker0/chezmoi.vim/issues
-- vim.schedule 确保在 chezmoi.vim 和 chezmoi.nvim 的回调均执行完后再覆盖文件类型。
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = {
    "*/chezmoi/dot_zshrc",
    "*/chezmoi/dot_zshenv",
    "*/chezmoi/dot_zprofile",
    "*/chezmoi/private_dot_zshrc",
    "*/chezmoi/private_dot_zshenv",
  },
  callback = function(ev)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ev.buf) then
        vim.bo[ev.buf].filetype = "zsh"
      end
    end)
  end,
})

vim.cmd([[
" Toggle relative line numbers automatically
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Turn on wrapping when editing text files
augroup Markdown
  autocmd!
  autocmd FileType markdown set wrap
	autocmd FileType text setlocal wrap
augroup END
]])
