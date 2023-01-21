local ok, jdtls_cfg = pcall(require, "lsp.jdtls")

if not ok then
	vim.notify("jdtls loading failed!", vim.log.levels.WARN)
	return
end
