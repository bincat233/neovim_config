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
opt.showmatch = true -- Show matching brackets
--opt.updatetime = 200 -- Faster completion
opt.pumblend = 18 -- Popup menu transparency
opt.breakindent = true -- Enable break indent
opt.softtabstop = -1 -- Let it follow shiftwidth

-- Cursor motion
--opt.scrolloff = 2 -- Keep N lines above and below the cursor
--opt.sidescrolloff=5 -- Keep columns left and right of cursor
--opt.backspace="indent,eol,start"
opt.matchpairs:append("<:>") -- Add angle brackets to matchpairs
--opt.display:append("lastline") -- Show last line when scrolling (显示不完整的最后一行)
--opt.signcolumn="auto:2-9" -- Always show signcolumn

-- Detect whether this session is connected over SSH
vim.g.is_ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil

-- Over SSH there's no local clipboard tool to shell out to, so route the
-- "+"/"*" registers through OSC 52 instead (works through the terminal, no
-- xclip/wl-copy/pbcopy needed). This transparently affects any mapping that
-- targets those registers, e.g. <leader>y in keymaps.lua.
if vim.g.is_ssh and vim.fn.has("nvim-0.10") == 1 then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end

-- System related configurations
if vim.fn.has("linux") == 1 then
  -- Linux specific configuration
  vim.g.is_linux = true
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Windows specific configuration
  vim.g.is_windows = true
elseif vim.fn.has("wsl") == 1 then
  -- WSL specific configuration
  vim.g.is_wsl = true
elseif vim.fn.has("mac") == 1 then
  -- macOS specific configuration
  -- Maybe enable dash.vim and vim-plist
  vim.g.is_mac = true
end

--vim.g.trouble_lualine = false -- Enable Winbar for lualine
-- Native inline completions don't support being shown as regular completions
--vim.g.ai_cmp = false

-- Configurations for different GUIs
if vim.g.neovide then
  -- If the GUI is Neovide
  -- opt.guifont = "Fira Code Nerd Font:h14"
  opt.guifont = "monospace:h11:#e-subpixelantialias"
  opt.linespace = 0
  --Disable mini.anamate
  vim.g.minianimate_disable = true
elseif vim.g.gonvim_running then
  -- If the GeI is Gonvim
  -- Useful commands: GonvimFilerOpen GonvimMiniMap
  -- GonvimWorkspaceNew GonvimWorkspaceNext GonvimWorkspacePrevious GonvimWorkspaceSwitch n
  -- Remove the eol character because Gonvim's cursor not compatible with it
  --opt.listchars = opt.listchars .. ",eol:\\ "
  vim.g.minianimate_disable = true
end

-- vimscript part
vim.cmd([[
iabbrev @@ isxiongzj@gmail.com " Set email address

" Set the mouse menu
" Remove the default menu
unmenu PopUp.-1-
unmenu PopUp.How-to\ disable\ mouse
]])
