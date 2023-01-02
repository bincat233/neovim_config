-- Notice that there are some basic keybindings set in the 
-- ~/.config/nvim/basic.vim
-- bufferline
-- Terminal相关
MY_SPLIT = ''
vim.keymap.set('n', '<A-v>', function() MY_SPLIT='' end)
vim.keymap.set('n', '<A-s-v>', function() MY_SPLIT='v' end)
vim.keymap.set("n", "<A-Enter>", function() vim.cmd(MY_SPLIT..'sp | terminal') end)

local uConfig = require("uConfig")
local keys = uConfig.keys

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- 本地变量
local map = vim.api.nvim_set_keymap

local opt = {
	noremap = true,
	silent = true,
}
--------------------------------------------------------------------------

-- leader key 为空
vim.g.mapleader = keys.leader_key
vim.g.maplocalleader = keys.leader_key

local opts_remap = {
	remap = true,
	silent = true,
}

local opts_expr = {
	expr = true,
	silent = true,
}

-- visual模式下缩进代码
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- 上下移动选中文本
keymap("x", "J", ":move '>+1<CR>gv-gv")
keymap("x", "K", ":move '<-2<CR>gv-gv")

-- 在visual mode 里粘贴不要复制
keymap("x", "p", '"_dP')

-- treesitter 折叠
keymap("n", keys.fold.open, ":foldopen<CR>")
keymap("n", keys.fold.close, ":foldclose<CR>")

-- Esc 回 Normal 模式
keymap("t", keys.terminal_to_normal, "<C-\\><C-n>")

----------------------------------------------------------------------
local M = {}

-- Set bufferline keys
function M.bufferline_keys_setup()
	-- My preferred mapping like i3wm
	map("n", "<a-h>", ":BufferLineCyclePrev<CR>", opt)
	map("n", "<a-l>", ":BufferLineCycleNext<CR>", opt)
	map("n", "<a-s-h>", ":BufferLineMovePrev<CR>", opt)
	map("n", "<a-s-l>", ":BufferLineMoveNext<CR>", opt)
	-- 左右Tab切换
	keymap("n", "<C-h>", ":BufferLineCyclePrev<CR>")
	keymap("n", "<C-l>", ":BufferLineCycleNext<CR>")
	-- "moll/vim-bbye" 关闭当前 buffer
	keymap("n", "<C-w>", ":Bdelete!<CR>")
	-- 关闭左/右侧标签页
	keymap("n", "<leader>bh", ":BufferLineCloseLeft<CR>")
	keymap("n",  "<leader>bl", ":BufferLineCloseRight<CR>")
	-- 关闭其他标签页
	keymap("n",  "<leader>bo", ":BufferLineCloseRight<CR>:BufferLineCloseLeft<CR>")
	-- 关闭选中标签页
	keymap("n",  "<leader>bp", ":BufferLinePickClose<CR>")
end

-- Global key mappings for nvim-tree
M.nvim_tree_keys_setup = function()
	map("n", "<A-f>", ":NvimTreeToggle<CR>", opt) -- Use Alt+f to toggle nvim-tree
	keymap("n", "<leader>ff", ":NvimTreeToggle<CR>")
	keymap("n", "<leader>fr", ":NvimTreeRefresh<CR>")
	keymap("n", "<leader>fn", ":NvimTreeFindFile<CR>")
end

-- Keymaps in the nvim-tree itself, See `:h nvim-tree-default-mappings`
M.nvim_tree_keys={
	{ key = {"g?"}, action = "toggle_help"},
}

-- For Treesitter module: Incremental selection
M.ts_selection_keys = {
	init_selection = "<C-RightMouse>",
	node_incremental = "<C-RightMouse>",
	node_decremental = "<C-LeftMouse>",
	scope_incremental = "<TAB>",
}

-- For LuaSnip module: Snippet Navigation
-- https://github.com/L3MON4D3/LuaSnip#keymaps
M.luasnip_keys_setup = function()
	local ls = require("luasnip")
	vim.keymap.set({ "i", "s" }, "<C-l>" , function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end)
	vim.keymap.set({ "i", "s" }, "<C-h>", function()
		if ls.jumpable(-1) then
			ls.jump(-1)
		end
	end)
	vim.keymap.set({ "i", "s" }, "<C-j>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end)
	vim.keymap.set({ "i", "s" }, "<C-k>", function()
		if ls.choice_active() then
			ls.change_choice(-1)
		end
	end)
end

-- For nvim-cmp module: Autocomplete
local cmp = safe_require("cmp")
if cmp then
	M.cmp_keys = {
		-- 出现补全
		["<A-.>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		-- 取消
		["<A-,>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- 确认
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({
			select = true,
			behavior = cmp.ConfirmBehavior.Replace,
		}),
		-- 如果窗口内容太多，可以滚动
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

		-- 上一个
		["<C-k>"] = cmp.mapping.select_prev_item(),
		-- 下一个
		["<C-j>"] = cmp.mapping.select_next_item(),
	}
end

-- For nvim-lspconfig module: LSP
M.lsp_globe_keys_setup = function()
	-- Diagnostic keys, copy from https://github.com/neovim/nvim-lspconfig#suggested-configuration
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	local opts = { noremap=true, silent=true }
	vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
	-- Config from nshen
	keymap("n", keys.format, "<cmd>lua vim.lsp.buf.formatting()<CR>")
end

M.lsp_on_attach_keys_setup = function(bufnr)
	-- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

return M
