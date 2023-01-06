let path = stdpath('config')
" NOTE: Use `gf` to open the file under the cursor
" ~/.config/nvim/basic.vim
exec 'source' path . '/basic.vim'
" ~/.config/nvim/nvim-basic.vim
exec 'source' path . '/nvim-basic.vim'
" ~/.config/nvim/plug.vim
exec 'source' path . '/plug.vim'
" ~/.config/nvim/coc.vim
exec 'source' path . '/coc.vim'


"==========DETECT OS==========
let uname=substitute(system('uname'), '\n', '', '')
if uname == 'Linux'
  if empty($DISPLAY) && empty($SSH_TTY) " In tty
    colorscheme solarized " 设置主题
    set background=dark " 日间/夜间背景
  else " In GUI or SSH
    colorscheme iceberg " 设置主题
    set background=light " 日间/夜间背景
  endif
endif


"""""""""""""""""""""""""""""""" 彩虹括号
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
			\ 'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
			\ 'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
			\ 'operators': '_,_',
			\ 'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
			\ 'separately': {
			\   '*': {},
			\   'tex': {
			\     'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
			\   },
			\   'lisp': {
			\     'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
			\   },
			\   'vim': {
			\     'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
			\   },
			\   'html': {
			\     'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
			\   },
			\   'css': 0,
			\ }
			\}

""""""""""""""""""""""""""""""""""""" vim-airline配置
if empty($DISPLAY) && empty($SSH_TTY) " In tty
	let g:airline_powerline_fonts = 0
	" If not in GUI or SSH, don't using "  "
else 
	let g:airline_powerline_fonts = 1
	let g:airline_left_sep = ' '
	let g:airline_left_alt_sep = '│'
	let g:airline_right_sep = ' '
	let g:airline_right_alt_sep = '│'
endif
let g:airline#extensions#tabline#enabled = 1 "只打开一个选项卡时自动显示所有缓冲区
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '│' "tab分隔符
"let g:airline#extensions#ale#enabled = 1 "检错airline支持,默认即开启
"let g:airline#extensions#coc#enabled = 1 "检错airline支持,默认即开启
let g:airline_mode_map = {} " 补全的时候不要显示 INSERT COMPL
let g:airline_mode_map['ic'] = 'INSERT' " 同上

""""""""""""""""""""""""""""""""""""""""""""""YouCompleteMe配置
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"let g:ycm_use_ultisnips_completer = 1 "提示UltiSnips
"let g:ycm_server_python_interpreter='/usr/local/bin/python3'
"let g:ycm_collect_identifiers_from_tags_files = 1 "开启YCM标签补全引擎
"let g:ycm_show_diagnostics_ui = 0 "关闭YCM辣鸡代码检测
"let g:ycm_enable_diagnostic_signs = 0
"let g:ycm_enable_diagnostic_highlighting = 0
"let g:ycm_seed_identifiers_with_syntax=1 "语言关键字补全
""自动语义补全
"let g:ycm_semantic_triggers = {
			"\ 'c,cpp,python,java,go,erlang,perl' : ['re!\w{2}'],
			"\ 'cs,lua,javascript' : ['re~\w{2}'],
"\}
"
"i3config
aug my_ft_detection
	au!
	au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
	au BufNewFile,BufRead ~/.local/share/chezmoi/dot_config/i3/config set filetype=i3config
	au BufNewFile,BufRead ~/.local/share/chezmoi/dot_zshrc set filetype=zsh
	au BufNewFile,BufRead ~/.config/fontconfig/fonts.conf set filetype=xml
	au BufNewFile,BufRead ~/.local/share/chezmoi/dot_config/fontconfig/fonts.conf set filetype=xml
	au BufNewFile,BufRead ~/.config/polybar/config set filetype=dosini
	au BufNewFile,BufRead ~/.local/share/chezmoi/dot_config/polybar/config set filetype=dosini
aug end


"""""""""""""""""""""" UltiSnips搜索跳转配置
"let g:UltiSnipsExpandTrigger = '<C-j>'
"let g:UltiSnipsJumpForwardTrigger = '<C-j>'
"let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
"let g:UltiSnipsSnippetsDir= stdpath('data') . '/plugged/vim-snippets/UltiSnips'
"let g:UltiSnipsSnippetDirectories=['UltiSnips']


"""""""""""""""""ALE配置""""""""""""""""""""
"let g:ale_sign_error = '>>'
"let g:ale_sign_warning = '--'
"let g:ale_completion_enabled = 0 "关闭补全
"let g:ale_sign_column_always = 1 "随时显示侧边栏
"let g:ale_vim_vint_executable = 'vint'
"highlight ALEError guibg=#D69E9B ctermbg=red cterm=undercurl
"highlight ALEWarning guibg=#EDECA9 ctermbg=yellow cterm=undercurl
""显示Linter名称,出错或警告等相关信息
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %severity%: %s'
""代码格式化配置,确保这些工具都已安装
"let g:ale_fixers = {
			"\ '*': ['remove_trailing_lines', 'trim_whitespace'],
			"\ 'javascript': ['eslint'],
			"\ 'json':['jq'],
			"\ 'c':['clang-format'],
			"\ 'cpp':['clang-format'],
			"\ 'lua':['luacheck'],
			"\ 'sh':['shfmt'],
			"\ 'zsh':['shfmt', 'remove_trailing_lines', 'trim_whitespace'],
			"\ 'sql':['sqlfmt'],
			"\ 'python':['black'],
			"\ 'markdown':['prettier'],
			"\ 'TypeScript':['prettier'],
			"\ 'xml':['xmllint']
"\}
"let g:ale_linters = {
			"\ 'python': ['flake8'],
			"\ 'reStructuredText': ['rstcheck'],
			"\ 'markdown': ['redpen', 'mdl']
"\}
"call ale#Set('python_black_options', ' -l 79')
""let g:ale_fix_on_save = 1 "自动格式化
""""""""""""""""""ALE END""""""""""""""""""""""""

""""""""""""""Gutentags: Ctag/Gtag设置""""""""""""""""""
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = '/usr/local/etc/gtags.conf'
"let $GTAGSCONF = '~/.globalrc'
set tags=./.tags;,.tags " CTag
" gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'
" 同时开启 ctags 和 gtags 支持：
let g:gutentags_modules = []
if executable('ctags')
	let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
	let g:gutentags_modules += ['gtags_cscope']
endif
" 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let g:gutentags_cache_dir = expand('~/.cache/tags')
" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" 如果使用 universal ctags 需要增加下面一行
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
" 禁用 gutentags 自动加载 gtags 数据库的行为
let g:gutentags_auto_add_gtags_cscope = 0

"""""""""""""""""""""""""""Leaderf
let g:Lf_StlColorscheme = 'one'
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
let g:Lf_ShowRelativePath = 0
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_PreviewResult = {'Function':0, 'Colorscheme':1}


""""""""""""""""""""""""" AsyncRun 编译运行
" 自动打开 quickfix window ，高度为 6
let g:asyncrun_open = 6
" 任务结束时候响铃提醒
let g:asyncrun_bell = 1

" 检测到文件类型为Python
"autocmd BufEnter *.py set conceallevel=2

""""""""""""""""""""""""""" vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='open'
let g:vimtex_quickfix_mode=0
" LaTeX代码隐藏或者替换成其他符号
let g:tex_conceal='abdmgs'

"""""""""""""""""""""""""" vim-markdown
""set conceallevel=2 " 代码隐藏, 隐藏或显示listchars定义的替换字符
"" 用vim-polyglot 禁止基于语法的隐藏
"let g:vim_json_syntax_conceal = 0
"let g:vim_markdown_conceal = 0
"let g:vim_markdown_conceal_code_blocks = 0
"" vim-markdown 兼容性设置
"let g:vim_markdown_math=1 " LaTeX
"let g:vim_markdown_folding_disabled = 1 " 禁止折叠
"
""""""""""""""""""""""""""" 缩进线
"let g:indentLine_char_list = ['|', '¦', '┆', '┊']
""autocmd BufEnter *.md,*.markdown,*.tex,*.latex IndentLinesToggle "为Markdown/LaTeX关闭缩进线以免插件冲突
""autocmd BufEnter *.md,*.markdown,*.tex,*.latex,*.sty,*.cls set concealcursor= "为Markdown/LaTeX关闭缩进线以免插件冲突
"
""""""""""""""""""""""""""" vim-hexokinase (显示文本颜色)
let g:Hexokinase_highlighters = ['foreground','sign_column'] " virtual sign_column background[full] foreground[full]
let g:Hexokinase_refreshEvents = ['BufWrite', 'BufRead','TextChanged', 'InsertLeave'] " BufWrite BufRead TextChanged InsertLeave

"=============== 快捷键配置=====================

"inoremap <Up> <>


""""""" jk 快速<esc> """""""
inoremap jk <esc>

"""""" 插入匹配括号 """""
" inoremap ( ()<LEFT>
" inoremap [ []<LEFT>
" inoremap { {}<LEFT>

""""" <F2> Leaderf快捷键 """""
noremap <F2> :LeaderfFunction!<CR>

""""" <F5> Python运行
noremap <F5> :AsyncRun -raw python % <cr>

""""" <F9> 格式化 formating """""
"" Using ALE to format code
"function! Fix()
"  ALEFix
"  retab
"endfunction
"nnoremap <F9> :call Fix()<CR>
"" Now I using COC to format code 
nnoremap <F9> :Format<CR>

""""" <F10> Nerdtree """""
noremap <F10> :NERDTreeToggle<CR>
noremap <A-f> :NERDTreeToggle<CR>

""""" <F10> 切换 asyncrun 的 Quickfix 窗口 """""
"nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>

"""""" 配置ale的linter功能: 普通模式下，sp前往上一个错误或警告，sn前往下一个错误或警告
"nmap <silent> sp <Plug>(ale_previous_wrap)
"nmap <silent> sn <Plug>(ale_next_wrap)

"""""" vim-multiple-cursors """""
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

"""""" YCM 定义处跳转 """""
"nnoremap <C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>
"<Leader>s触发/关闭语法检查
"nmap <Leader>s :ALEToggle<CR>
"<Leader>d查看错误或警告的详细信息
"nmap <Leader>d :ALEDetail<CR>

""""" <ESC> 退出LeaderF """""
let g:Lf_NormalMap = {
			\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
			\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
			\ "Mru":    [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
			\ "Tag":    [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
			\ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>'],["<F2>",':exec g:Lf_py "functionExplManager.quit()"<CR>']],
			\ "Colorscheme":    [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
			\ }


