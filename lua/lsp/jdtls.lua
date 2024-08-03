local ok, jdtls = pcall(require, "jdtls")
-- if jdtls is not installed, give a warning and return
-- https://stackoverflow.com/questions/74844019/neovim-setting-up-jdtls-with-lsp-zero-mason
if not ok then
	vim.notify("jdtls is not installed!", vim.log.levels.WARN)
	return
end

-- if jdtls is installed, give a warning and return
--local jdtls_exec = vim.fn.stdpath('data') .. '/mason/bin/jdtls'
--if not vim.fn.executable(jdtls_exec) then
--	jdtls_exec = "jdtls"
--	if not vim.fn.executable(jdtls_exec) then
--		vim.notify('jdtls is not installed!', vim.log.levels.WARN)
--		return
--	end
--end

-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_markers = { ".gradlew", ".gradlew", ".git", "mvnw", ".root" }
--local project_dir = vim.fs.dirname(vim.fs.find(project_marker, { upward = true })[1])
local project_dir = jdtls.find_root(project_markers)
if not project_dir then
	project_dir = vim.fn.getcwd()
end

local project_name = vim.fn.fnamemodify(project_dir, ":p:h:t")
local cache_dir = vim.fn.expand("$HOME") .. "/.cache/nvim_jdtls/"

local workspace_dir = cache_dir .. "nvim_jdtls/workspace/" .. project_name
-- If workspace_root_dir doesn't exist, create it
if vim.fn.isdirectory(workspace_dir) == 0 then
	vim.fn.mkdir(workspace_dir, "p")
end

local jdtls_exec = "jdtls"
local config = {
	cmd = {
		jdtls_exec,
		--"-configuration", "/home/bear/.cache/jdtls/config",
		--'-data', '/home/bear/.cache/jdtls/workspace',

		--'-configuration', cache_dir .. 'config',
		"-data", workspace_dir,
	},
	root_dir = project_dir,
	on_attach = function (client, bufnr)
		require('keybindings').lsp_on_attach_keys_setup(bufnr)
		require('lsp.lsp_signature').setup(bufnr)
	end,
}

jdtls.start_or_attach(config)
