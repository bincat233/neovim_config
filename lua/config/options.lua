-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.clipboard = "" -- Don't use the system clipboard
opt.ignorecase = true -- Ignore case when searching  -- 忽略大小写
opt.smartcase = true -- Override 'ignorecase' if the search pattern contains uppercase characters
opt.wildmenu = true -- Show command-line completion candidates in a horizontal menu
opt.nrformats:remove("octal") -- Don't use octal numbers when incrementing/decrementing with CTRL-A/CTRL-X
opt.autoread = true -- Automatically read file when it changes
opt.whichwrap:append("<,>,[,]") -- Move to next line with theses keys
--opt.foldmethod = "syntax" -- Fold based on syntax
--opt.completeopt = "menu,menuone,noinsert"
--opt.completeopt = "menu,menuone,noselect,noinsert"
--opt.timeoutlen = 500 -- Time to wait for a mapped sequence to complete (in milliseconds)
opt.cursorline = true -- Highlight current line
opt.cursorcolumn = true -- Highlight current column
opt.mousemoveevent = true -- Enable mouse support
opt.wildmenu = true -- Show command-line completion candidates in a horizontal menu
opt.showmatch = true -- Show matching brackets
--opt.updatetime = 200 -- Faster completion
opt.pumblend = 18 -- Popup menu transparency

-- Cursor motion
--opt.scrolloff = 2 -- Keep N lines above and below the cursor
--opt.sidescrolloff=5 -- Keep columns left and right of cursor
--opt.backspace="indent,eol,start"
opt.matchpairs:append("<:>") -- Add angle brackets to matchpairs
--opt.display:append("lastline") -- Show last line when scrolling (显示不完整的最后一行)
--opt.signcolumn="auto:2-9" -- Always show signcolumn

-- System related configurations
if vim.fn.has("linux") == 1 then
  -- Linux specific configuration
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Windows specific configuration
elseif vim.fn.has("wsl") == 1 then
  -- WSL specific configuration
elseif vim.fn.has("mac") == 1 then
  -- macOS specific configuration
  -- Maybe enable dash.vim and vim-plist
end

--vim.g.trouble_lualine = false -- Enable Winbar for lualine

-- Configurations for different GUIs
if vim.g.neovide then
  -- If the GUI is Neovide
  -- vim.o.guifont = "Fira Code Nerd Font:h14"
  vim.o.guifont = "monospace:h10:#e-subpixelantialias"
  --Disable mini.anamate
  vim.g.minianimate_disable = true
elseif vim.g.gonvim_running then
  -- If the GUI is Gonvim
  -- Useful commands: GonvimFilerOpen GonvimMiniMap
  -- GonvimWorkspaceNew GonvimWorkspaceNext GonvimWorkspacePrevious GonvimWorkspaceSwitch n
  -- Remove the eol character because Gonvim's cursor not compatible with it
  --vim.o.listchars = vim.o.listchars .. ",eol:\\ "
  vim.g.minianimate_disable = true
end

-- vimscript part
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

iabbrev @@ isxiongzj@gmail.com " Set email address

" Set the mouse menu
" Remove the default menu
unmenu PopUp.-1- 
unmenu PopUp.How-to\ disable\ mouse
]])
