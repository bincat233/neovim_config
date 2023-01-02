if vim.g.neovide then
	vim.g.beacon_enable=0
else
	vim.cmd [[
		highlight Beacon guibg=#F56A6B ctermbg=15
		let g:beacon_minimal_jump = 10
		nmap <silent> n n:Beacon<cr>
		nmap <silent> N N:Beacon<cr>
		nmap <silent> * *:Beacon<cr>
		nmap <silent> # #:Beacon<cr>
	]]
end
