local M = {}

-- M.capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.flags = {
  debounce_text_changes = 150,
}

return M
