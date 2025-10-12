-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufReadPost" }, {
  pattern = vim.fn.expand("$HOME") .. "/.config/sway/**/*.conf",
  command = "set filetype=swayconfig",
})

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
