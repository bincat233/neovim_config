-- Github: https://github.com/lukas-reineke/indent-blankline.nvim
local status, ident_blankline = pcall(require, "ibl")
if not status then
  vim.notify("Indent_blankline not found!")
  return
end

--TODO: This is config of v2 version, need to be updated to v3
--vim.opt.list = true
---- Setted in ~/.config/nvim/basic.vim
----vim.opt.listchars:append "space:⋅"
----vim.opt.listchars:append "eol:↴"
--
--ident_blankline.setup({
--  -- 空行占位
--  space_char_blankline = " ",
--  -- 用 treesitter 判断上下文
--  show_current_context = true,
--  show_current_context_start = true,
--  context_patterns = {
--    "class",
--    "function",
--    "method",
--    "element",
--    "^if",
--    "^while",
--    "^for",
--    "^object",
--    "^table",
--    "block",
--    "arguments",
--  },
--  -- :echo &filetype
--  filetype_exclude = {
--    "dashboard",
--    "packer",
--    "terminal",
--    "help",
--    "log",
--    "markdown",
--    "TelescopePrompt",
--    "lsp-installer",
--    "lspinfo",
--    "toggleterm",
--  },
--  -- 竖线样式
--  -- char = '¦'
--  -- char = '┆'
--  -- char = '│'
--  -- char = "⎸",
--  char = "▏",
--})
