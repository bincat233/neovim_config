M={}

local signature_setup = {
	-- 边框浮动窗口
	bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded"
  }
}

M.setup = function(bufnr)
  require "lsp_signature".on_attach(signature_setup, bufnr)  -- Note: add in lsp client on-attach
end

return M
