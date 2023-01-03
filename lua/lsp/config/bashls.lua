local common = require("lsp.common-config")
local keys = require("keybindings")
local opts = {
  capabilities = common.capabilities,
  flags = common.flags,
  on_attach = function(client, bufnr)
    common.disableFormat(client)
		keys.lsp_on_attach_keys_setup(bufnr)
  end,
}
return {
  on_setup = function(server)
    server.setup(opts)
  end,
}
