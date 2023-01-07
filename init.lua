-- Use `gf` to open files under the cursor

-- Get the path to the config dir
--local config_dir = vim.fn.stdpath('config')
_G.CONFIG_DIR = vim.api.nvim_list_runtime_paths()[1]
-- Function to source vimscript files
function _G.source_viml(file)
	vim.cmd("source " .. CONFIG_DIR .. "/" .. file)
end

-- A function to print lua tables. It's useful for debugging
-- Usage: `:lua put(foo)`
function _G.put(...)
	local objects = {}
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		table.insert(objects, vim.inspect(v))
	end
	print(table.concat(objects, "\n"))
	return ...
end

function _G.keymap(mode, lhs, rhs, opts)
	if not (type(lhs) == "string") then
		return
	end
	if not (type(rhs) == "string") then
		return
	end
	opts = opts or {}
	local default_opts = {
		remap = false,
		silent = true,
	}
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", default_opts, opts))
end

function _G.safe_require(module_name)
	local status, module = pcall(require, module_name)
	if not status then
		vim.notify(module_name .. " not found!")
		return nil
	end
	return module
end

-- Load minimal settings
-- Open files with `gf` under the cursor
source_viml("basic.vim") -- ~/.config/nvim/basic.vim
source_viml("nvim-basic.vim") -- ~/.config/nvim/nvim-basic.vim
-- Packer plugin manager, configs moved to plugins.lua
require("plugins") -- ~/.config/nvim/lua/plugins.lua
-- Load keybindings
require("keybindings") -- ~/.config/nvim/lua/keybindings.lua
-- Colorscheme
require("colorscheme") -- ~/.config/nvim/lua/colorscheme.lua
-- LSP
require("lsp.setup") -- ~/.config/nvim/lua/lsp/setup.lua
require("cmp.setup") -- ~/.config/nvim/lua/cmp/setup.lua
require("format.setup") -- ~/.config/nvim/lua/format/setup.lua
