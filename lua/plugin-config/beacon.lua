if vim.g.neovide then
	vim.g.beacon_enable=0
else
	vim.cmd [[
		" If colorscheme is iceberg, change the color of beacon
		" FIXME: 不太优雅
		let current_scheme = get(g:, 'colors_name', 'default')
		if current_scheme == 'iceberg'
			highlight Beacon guibg=#F56A6B ctermbg=15
		endif
		autocmd ColorScheme iceberg highlight Beacon guibg=#F56A6B ctermbg=15
	  
		" Other settings
		let g:beacon_minimal_jump = 10
		nmap <silent> n n:Beacon<cr>
		nmap <silent> N N:Beacon<cr>
		nmap <silent> * *:Beacon<cr>
		nmap <silent> # #:Beacon<cr>
	]]
end
