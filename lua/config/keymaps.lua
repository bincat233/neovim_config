-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local wkadd = require("which-key").add

-- Use leader key + u v to toggle list mode on/off
map("n", "<leader>ul", ":set list!<CR>", { desc = "Toggle list mode [user]" })

-- Use jk to escape insert mode
map("i", "jk", "<esc>")

-- Copy/Paste to system clipboard
wkadd({
  mode = { "n", "v" },
  { "<leader>y", '"+y', desc = "Copy to system clipboard", icon = " " },
  { "<leader>d", '"+d', desc = "Delete to system clipboard", icon = " " },
  { "<leader>p", '"+p', desc = "Paste from system clipboard", icon = " " },
  { "<leader>P", '"+P', desc = "Paste from system clipboard", icon = " " },
})

-- UI - Reload vimrc
map("n", "<leader>uS", ":source $HOME/.config/nvim/init.lua<cr>", { desc = "source config files [user]" })

-- <C-s-v> in all mode to paste
map({ "n", "v", "x", "s" }, "<C-S-v>", '"+p')
-- <C-s-c> in visual mode to copy
map({ "v", "x" }, "<C-S-c>", '"+y')
-- <C-s-x> in visual mode to cut
map({ "v", "x" }, "<C-S-x>", '"+d')

-- Move selected text
map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move selected text down [user]" })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move selected text up [user]" })

-- Delete Keymap of help manual
map({ "n", "v", "i" }, "<F1>", "<Nop>")

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

map("v", "<C-t>", ":Translate ZH<CR>gv", { desc = "Translate selection", silent = false })
map("i", "<C-t>", "<Esc>m`V:Translate -output=insert EN<CR>k``a", { desc = "Translate selection", silent = false })
wkadd({ "<leader>t", nil, desc = "translation", icon = "" })
map("n", "<leader>tw", "m`viw:Translate ZH<CR>``", { desc = "Translate word under cursor" })
map("n", "<leader>tt", "m`V:Translate ZH<CR>``", { desc = "Translate line under cursor" })
--map("n", "<space>ta", "ggVG:Translate -output=split ZH<CR>", { desc = "Translate the page" })
map("n", "<leader>ta", function()
  -- Save the current cursor position
  local current_pos = vim.fn.getpos(".")
  -- Select full text
  vim.cmd("normal! ggVG")
  -- Execute translation
  vim.cmd("Translate -output=split ZH")
  -- Exit visual mode
  vim.api.nvim_input("<ESC>")
  -- Restore cursor position
  vim.fn.setpos(".", current_pos)
end, { desc = "Translate the page" })
--map("i", "<C-t>", "<ESC>V:Translate -output=insert ZH<CR>", { silent = true })
