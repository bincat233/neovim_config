-- Set colorscheme with fallbacks
local function set_cs(...)
	for _, cs in ipairs{...}  do
		local status_ok, _ = pcall(vim.cmd, "colorscheme " .. cs)
		if not status_ok then
		  vim.notify('Colorscheme "' .. cs .. '" not found！')
		else
			return
		end
	end
end

-- Compatability with Linux TTYS
if os.getenv('DISPLAY') == nil and os.getenv('SSH_TTY') == nil then -- If under TTY
	set_cs(
		"solarized",
		"base16-default-dark"
	) -- Set colorscheme to solarized
	vim.o.background = "dark"
else -- If under GUI
	set_cs(
		"iceberg",
		"tokyonight-day",
		"catppuccin-latte",
		"github-theme",
		"seoul256",
		"gruvbox",
		"two-firewatch"
	) -- Set colorscheme to iceberg
	vim.o.background = "light"
end

-- 变量名高亮
vim.cmd [[
" highlight the definition of a variable
hi LspReferenceWrite cterm=bold ctermbg=LightYellow guibg=#acc5dc
hi def IlluminatedWordWrite guibg=#acc5dc

" highlight the usage of a variable
hi LspReferenceRead cterm=bold ctermbg=LightYellow guibg=#ced9e1
hi def IlluminatedWordRead guibg=#ced9e1

" highlight the text of a variable
hi LspReferenceText cterm=bold ctermbg=LightYellow guibg=#e3d2da
hi def IlluminatedWordText guibg=#e3d2da
]]
