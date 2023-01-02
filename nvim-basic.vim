" The Neovim basic configuration
" Contains the configurations withouth plugins

" Set the mouse menu
" Remove the default menu
unmenu PopUp.-1-
unmenu PopUp.How-to\ disable\ mouse

" Show signcolumn only when needed
set signcolumn=auto:2-9 

"" System related configurations
"" If the system is Windows
"if has('linux')
"elseif has('win32') || has('win64')
"elseif has('wsl')
"elseif has('mac')
"	" Maybe enable dash.vim and vim-plist
"endif

" Configurations for different GUIs
if exists('g:neovide') " If the GUI is Neovide
	"set guifont=Fira\ Code\ Nerd\ Font:h14
	set guifont=monospace:h12:#e-subpixelantialias
elseif exists('g:gonvim_running') " If the GUI is Gonvim
	"Useful command: GonvimFilerOpen GonvimMiniMap
	"GonvimWorkspaceNew GonvimWorkspaceNext GonvimWorkspacePrevious GonvimWorkspaceSwitch n
	set listchars+=eol:\  " Remove the eol character because Gonvim's cursor not compatible with it
endif
