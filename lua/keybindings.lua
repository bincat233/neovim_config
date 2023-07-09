-- Notice that there are some basic keybindings set in the
-- ~/.config/nvim/basic.vim
-- <C-s-c> in visual mode to copy
-- <C-s-v> in all mode to paste
-- <C-s-x> in visual mode to cut
vim.keymap.set({ "n", "v", "s" }, "<C-S-v>", '"+p')
vim.keymap.set("v", "<C-S-c>", '"+y')
vim.keymap.set("v", "<C-S-x>", '"+d')

-- bufferline
-- Terminal相关
--MY_SPLIT = ""
--vim.keymap.set("n", "<A-v>", function()
--	MY_SPLIT = ""
--end)
--vim.keymap.set("n", "<A-s-v>", function()
--	MY_SPLIT = "v"
--end)
--vim.keymap.set("n", "<A-Enter>", function()
--	vim.cmd(MY_SPLIT .. "sp | terminal")
--end)

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
	--keymap("n", "<C-w>", ":Bdelete!<CR>")
	-- 关闭左/右侧标签页
	keymap("n", "<leader>bh", ":BufferLineCloseLeft<CR>")
	keymap("n", "<leader>bl", ":BufferLineCloseRight<CR>")
	-- 关闭其他标签页
	keymap("n", "<leader>bo", ":BufferLineCloseRight<CR>:BufferLineCloseLeft<CR>")
	-- 关闭选中标签页
	keymap("n", "<leader>bp", ":BufferLinePickClose<CR>")
end

-- Global key mappings for nvim-tree
M.nvim_tree_keys_setup = function()
	map("n", "<A-f>", ":NvimTreeToggle<CR>", opt) -- Use Alt+f to toggle nvim-tree
	--map("n", "<leader>ft", ":NvimTreeToggle<CR>", opt) -- Use Alt+f to toggle nvim-tree
	--keymap("n", "<leader>ff", ":NvimTreeToggle<CR>")
	--keymap("n", "<leader>fr", ":NvimTreeRefresh<CR>")
	--keymap("n", "<leader>fn", ":NvimTreeFindFile<CR>")
end

-- Keymaps in the nvim-tree itself, See `:h nvim-tree-default-mappings`
M.nvim_tree_keys = {
	{ key = { "g?" }, action = "toggle_help" },
}

-- For Treesitter module: Incremental selection
-- https://github.com/nvim-treesitter/nvim-treesitter#incremental-selection
-- ~/.config/nvim/lua/plugin-config/nvim-treesitter.lua
M.ts_selection_keys = {
	init_selection = "<Plug>gnn", -- set to `false` to disable one of the mappings
	node_incremental = "<Plug>grn",
	scope_incremental = "<Plug>grc",
	node_decremental = "<Plug>grm",
}

M.ts_keys_setup = function()
	-- Treesitter 折叠
	keymap("n", "zo", ":foldopen<CR>")
	keymap("n", "zc", ":foldclose<CR>")
	-- Treesitter incremental selection
	vim.keymap.set("n", "<A-LeftMouse>", "<Plug>gnn", { remap = true, silent = true }) -- Alt-LeftMouse to incremental select
	vim.keymap.set("n", "<A-RightMouse>", "<Plug>gnn", { remap = true, silent = true }) -- Alt-LeftMouse to incremental select
	vim.keymap.set("v", "<A-LeftMouse>", "<Plug>grn", { remap = true, silent = true })
	vim.keymap.set("v", "<Tab>", "<Plug>grn", { remap = true, silent = true }) -- Tab to expand selection
	vim.keymap.set("v", "<A-RightMouse>", "<Plug>grm", { remap = true, silent = true }) -- Alt-RightMouse to reduce selection
	vim.keymap.set("v", "<S-Tab>", "<Plug>grm", { remap = true, silent = true }) -- Shift-Tab to reduce selection
end

-- For LuaSnip module: Snippet Navigation
-- https://github.com/L3MON4D3/LuaSnip#keymaps
M.luasnip_keys_setup = function()
	local ls = require("luasnip")
	vim.keymap.set({ "i", "s" }, "<C-l>", function()
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
-- ~/.config/nvim/lua/cmp/setup.lua
-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
local cmp = safe_require("cmp")
if cmp then
	M.cmp_keys = {
		-- 出现补全
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }), -- ME: Like IDEA
		-- 取消
		["<C-c>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<C-h>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true, -- Perselect first item
		}),
		-- 确认
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<C-CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true, -- Perselect first item
		}),
		["<C-l>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true, -- Perselect first item
		}),
		-- 如果窗口内容太多，可以滚动
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-8), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(8), { "i", "c" }),

		-- 上一个
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<Up>"] = cmp.mapping.select_prev_item(),
		-- 下一个
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<Down>"] = cmp.mapping.select_next_item(),
	}
end

-- For Copilot
M.copilot_keys_config = function()
	-- Map <M-Bslash> to toggle copilot
	vim.cmd([[
	inoremap <expr> <M-Bslash> copilot#GetDisplayedSuggestion().text == "" ? copilot#Suggest() : copilot#Dismiss()
	]])
end

-- For nvim-lspconfig module: LSP
M.lsp_globe_keys_setup = function()
	-- Diagnostic keys, copy from https://github.com/neovim/nvim-lspconfig#suggested-configuration
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	local opts = { noremap = true, silent = true }

	-- Default keymap options
	--vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
	--vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	--vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

	-- Lspsaga keys
	local bmap = vim.api.nvim_buf_set_keymap
	bmap(0, "n", "<leader>e", "<cmd>Lspsaga show_line_diagnostics<cr>", { silent = true, noremap = true })
	bmap(0, "n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { silent = true, noremap = true })
	bmap(0, "n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", { silent = true, noremap = true })
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end)
end

M.lsp_on_attach_keys_setup = function(bufnr)
	-- See also: https://github.com/junnplus/lsp-setup.nvim#setup-structure
	-- Also copy from https://github.com/neovim/nvim-lspconfig#suggested-configuration

	-- NOTE: Global keys: For all conditions

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)

	-- NOTE: Only for lspconfig default version
	--vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	--vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
	--vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

	-- NOTE: Only for lspsaga, See: https://github.com/kkharji/lspsaga.nvim#example-keymapings
	-- My keymap follows the default keymap of lspconfig, and diagnostic keys setted in lsp_globe_keys_setup()
	local bmap = vim.api.nvim_buf_set_keymap
	bmap(0, "n", "<leader>rn", "<cmd>Lspsaga rename<cr>", { silent = true, noremap = true })
	bmap(0, "n", "<leader>ca", "<cmd>Lspsaga code_action<cr>", { silent = true, noremap = true })
	bmap(0, "x", "<leader>ca", ":<c-u>Lspsaga range_code_action<cr>", { silent = true, noremap = true })
	bmap(0, "n", "K", "<cmd>Lspsaga hover_doc<cr>", { silent = true, noremap = true })
	bmap(0, "n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", {})
	bmap(0, "n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", {})
	keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>") -- Toglle Outline

	-- NOTE: Only for telescope
	-- go xx
	--mapbuf("n", lsp.definition, function()
	--  require("telescope.builtin").lsp_definitions({
	--    initial_mode = "normal",
	--    -- ignore_filename = false,
	--  })
	--end)

	--mapbuf(
	--  "n",
	--  lsp.references,
	--  "<cmd>lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_ivy())<CR>"
	--)
end

-- NOTE: ~/.config/nvim/lua/plugin-config/todo-comments.lua
M.todo_comments_keys_setup = function()
	-- Copy from https://github.com/folke/todo-comments.nvim#jumping
	vim.keymap.set("n", "]t", function()
		require("todo-comments").jump_next()
	end, { desc = "Next todo comment" })

	vim.keymap.set("n", "[t", function()
		require("todo-comments").jump_prev()
	end, { desc = "Previous todo comment" })

	-- You can also specify a list of valid jump keywords
	--vim.keymap.set("n", "]t", function()
	--	require("todo-comments").jump_next({keywords = { "ERROR", "WARNING" }})
	--end, { desc = "Next error/warning todo comment" })
end

-- NOTE: ~/.config/nvim/lua/plugin-config/gitsigns.lua
M.gitsigns_keys_setup = function(bufnr)
	local gs = package.loaded.gitsigns

	local function map(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	-- Navigation
	map("n", "]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	map("n", "[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	-- Actions
	map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
	map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
	map("n", "<leader>hS", gs.stage_buffer)
	map("n", "<leader>hu", gs.undo_stage_hunk)
	map("n", "<leader>hR", gs.reset_buffer)
	map("n", "<leader>hp", gs.preview_hunk)
	map("n", "<leader>hb", function()
		gs.blame_line({ full = true })
	end)
	map("n", "<leader>tb", gs.toggle_current_line_blame)
	map("n", "<leader>hd", gs.diffthis)
	map("n", "<leader>hD", function()
		gs.diffthis("~")
	end)
	map("n", "<leader>td", gs.toggle_deleted)

	-- Text object
	map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

M.aerial_keys_setup = function(bufnr)
	-- Jump forwards/backwards with '{' and '}'
	vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
	vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
end

M.aerial_global_keys_setup = function()
	-- Open/close the Aerial window with '<C-t>'
	vim.keymap.set("n", "<A-j>", "<cmd>AerialToggle!<CR>")
end

M.jdtls_global_keys_setup = function()
	-- https://github.com/mfussenegger/nvim-jdtls#usage
	vim.cmd([[
	nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
	nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
	vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
	nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
	vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
	vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>
	
	"" If using nvim-dap
	"" This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
	"nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
	"nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
	]])
end

return M
