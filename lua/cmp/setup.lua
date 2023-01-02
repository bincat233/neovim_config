-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/onsails/lspkind-nvim
local cmp=safe_require("cmp")
local luasnip=safe_require("luasnip")
local config=safe_require("uConfig")
local keybindings = safe_require("keybindings")
if not cmp or not luasnip or not config or not keybindings then return end

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	-- 指定 snippet 引擎 luasnip
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	-- 快捷键
	-- Mapping in the keybindings.lua
	mapping = keybindings.cmp_keys,
	-- 来源
	sources = cmp.config.sources({
		{
			name = "luasnip",
			group_index = 1,
		},
		{
			name = "nvim_lsp",
			group_index = 1,
		},
		{
			name = "nvim_lsp_signature_help",
			group_index = 1,
		},
		{
			name = "buffer",
			group_index = 2,
		},
		{
			name = "path",
			group_index = 2,
		},
	}),

	-- 使用lspkind-nvim显示类型图标
	formatting = require("cmp.lspkind").formatting,
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { {
		name = "buffer",
	} },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ {
		name = "path",
	} }, { {
			name = "cmdline",
		} }),
})

cmp.setup.filetype({ "markdown", "help" }, {
	sources = { {
		name = "luasnip",
	}, {
			name = "buffer",
		}, {
			name = "path",
		} },
})

require("cmp.luasnip")
