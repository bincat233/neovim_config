---- A function to map keys
--function _G.keymap(mode, lhs, rhs, opts)
--	if not (type(lhs) == "string") then
--		return
--	end
--	if not (type(rhs) == "string") then
--		return
--	end
--	opts = opts or {}
--	local default_opts = {
--		remap = false,
--		silent = true,
--	}
--	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", default_opts, opts))
--end

-- Get strucutre of a table
_G.utils = require("local.utils")
_G.obj_dump = _G.utils.obj_dump

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
