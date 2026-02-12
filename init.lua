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

-- Set `in_editor` variable in Kitty terminal to `1` when entering Neovim
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
  end,
})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
