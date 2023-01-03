local ls = safe_require("luasnip")
local keys = require("keybindings")
local types = safe_require("luasnip.util.types")
if not ls or not keys or not types then return end

-- custom snippets
safe_require("luasnip.loaders.from_lua").load({
	paths = CONFIG_DIR .. "/lua/cmp/snippets/lua",
})
safe_require("luasnip.loaders.from_vscode").lazy_load({
	paths = CONFIG_DIR .. "/lua/cmp/snippets/vscode",
})

-- https://github.com/rafamadriz/friendly-snippets/
safe_require("luasnip.loaders.from_vscode").lazy_load()

-- https://github.com/L3MON4D3/LuaSnip#config
ls.config.set_config({
	history = true,
	update_events = "TextChanged,TextChangedI",
	enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = { -- Show arrow when the node is active
				-- virt_text = { { "choiceNode", "Comment" } },
				virt_text = { { "<--", "Error" } },
			},
		},
	},
})

-- ~/.config/nvim/lua/keybindings.lua
keys.luasnip_keys_setup()
