-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local wkadd = require("which-key").add

if vim.g.neovide == true then
  vim.keymap.set({ "n", "x" }, "<C-S-C>", '"+y', { desc = "Copy system clipboard" })
  vim.keymap.set({ "n", "x" }, "<C-S-V>", '"+p', { desc = "Paste system clipboard" })
end

-- Use leader key + u I to toggle list mode on/off
map("n", "<leader>uI", ":set list!<CR>", { desc = "Toggle list mode (invisible chars) [user]" })

-- Use jk to escape insert mode
map("i", "jk", "<esc>")

-- Copy/Paste to system clipboard
-- NOTE: 不设置 <leader>d，因为与 LazyVim 的 DAP 调试器命令族冲突（<leader>db/dc/di 等），且容易导致按键延迟；剪切可使用 <C-S-x> 或直接用 y+d
wkadd({
  mode = { "n", "v" },
  { "<leader>y", '"+y', desc = "Copy to system clipboard", icon = " " },
  { "<leader>p", '"+p', desc = "Paste from system clipboard", icon = " " },
  { "<leader>P", '"+P', desc = "Paste from system clipboard", icon = " " },
})

-- UI - Reload vimrc
map("n", "<leader>uR", ":source $HOME/.config/nvim/init.lua<cr>", { desc = "Reload config files [user]" })

-- <C-s-v> in all mode to paste
map({ "n", "v", "x", "s" }, "<C-S-v>", '"+p')
-- <C-s-c> in visual mode to copy
map({ "v", "x" }, "<C-S-c>", '"+y')
-- <C-s-x> in visual mode to cut
map({ "v", "x" }, "<C-S-x>", '"+d')

-- Move selected text
-- TODO: 待弃用。推荐改用 LazyVim 原生的 <A-j> / <A-k> 移动代码行，避免占用 Visual 模式的原生 J (行合并) 功能
map("x", "J", function()
  vim.notify("建议改用 <A-j> 移动代码行（避免占用 J 的行合并功能）", vim.log.levels.WARN, {
    title = "Keymap Deprecation",
    id = "move_lines_deprecation",
  })
  return vim.api.nvim_replace_termcodes(":move '>+1<CR>gv-gv", true, false, true)
end, { expr = true, desc = "Move selected text down [user] (TODO: 待弃用 -> <A-j>)" })

map("x", "K", function()
  vim.notify("建议改用 <A-k> 移动代码行（避免占用 J 的行合并功能）", vim.log.levels.WARN, {
    title = "Keymap Deprecation",
    id = "move_lines_deprecation",
  })
  return vim.api.nvim_replace_termcodes(":move '<-2<CR>gv-gv", true, false, true)
end, { expr = true, desc = "Move selected text up [user] (TODO: 待弃用 -> <A-k>)" })

-- Delete Keymap of help manual
map({ "n", "v", "i" }, "<F1>", "<Nop>")
-- Ignore <D-Space> (Super/Win + Space, a global shortcut for voxtype)
map({ "n", "v", "x", "s", "i", "o", "c", "t" }, "<D-Space>", "<Nop>", { silent = true })

-- When paste in visual mode, don't copy it
--map("x", "p", '"_dP')

-- Using Esc in Terminal mode returns to Normal mode
--map("t", "<Esc>", "<C-\\><C-n>")
-- Treesitter folding
--map("n", "zo", ":foldopen<CR>", { silent = true })
--map("n", "zc", ":foldclose<CR>", { silent = true })
-- Treesitter incremental selection
map({ "n", "x" }, "<A-RightMouse>", "<C-Space>", { remap = true, silent = true }) --init_selection / node_incremental: Alt-LeftMouse to incremental select
map("x", "<A-LeftMouse>", "<bs>", { remap = true, silent = true }) --node_decremental: Alt-RightMouse to reduce selection

--map("n", "<A-f>", ":NvimTreeToggle<CR>", opt) -- Use Alt+f to toggle nvim-tree

wkadd({ "<leader>T", nil, desc = "translation", icon = "" })

--map("i", "<C-t>", "<ESC>V:Translate -output=insert ZH<CR>", { silent = true })
