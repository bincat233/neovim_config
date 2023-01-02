-- To configure each LSP server, create config file in ~/.config/nvim/lua/lsp/config
-- The file name must be the same as the server name in this url (Use `gx` to open the link)
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers

local mason = require("mason")
local mason_config = require("mason-lspconfig")
local lspconfig = require("lspconfig")

if not mason or not mason_config or not lspconfig then
	vim.notify("mason, mason-lspconfig, and lspconfig are required for this plugin to work", vim.log.levels.ERROR)
	return
end

-- :h mason-default-settings
-- ~/.local/share/nvim/mason
mason.setup({
	ui = {
		--border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- mason-lspconfig uses the `lspconfig` server names in the APIs it exposes - not `mason.nvim` package names
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
mason_config.setup({
	ensure_installed = {
		"bashls",
		"clangd",
		"cmake",
		"rust_analyzer",
		"sumneko_lua",
	},
})

-- Automatic server setup
local handlers = {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function (server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {}
	end,
	---- Next, you can provide targeted overrides for specific servers. For example:
	--["sumneko_lua"] = function ()
	--	lspconfig.sumneko_lua.setup { settings = { } }
	--end,
}
-- Loop through all files in the lsp config directory (~/.config/nvim/lua/lsp/config)
-- file name must be the same as the server name in this url (Use `gx` to open the link)
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config')..'/lua/lsp/config', [[v:val =~ '\.lua$']])) do
	local server_name = file:match('(.*)%.lua')
	--vim.notify("LSP " .. server_name .. " setup", vim.log.levels.INFO)
	handlers[server_name] = function ()
		require('lsp.config.'..server_name).on_setup(lspconfig[server_name])
	end
end
mason_config.setup_handlers(handlers)

require('lsp.ui')
