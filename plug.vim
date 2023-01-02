call plug#begin(stdpath('data') . '/plugged')
" Plugins go here
" Know that powerful tools require powerful control
" 须知强力工具需要强力掌控
" 
" =====主题=====
Plug 'cocopon/iceberg.vim'    " 配合 arc theme
Plug 'altercation/vim-colors-solarized' " solarized主题
"Plug 'junegunn/seoul256.vim'  " 超好看的低对比度主题
"Plug 'RRRRRm/seoul256-airline' " airline支持
"Plug 'morhetz/gruvbox'        " gruvbox主题
"Plug 'nightsense/strawberry'  " 粉色vim主题
"Plug 'soft-aesthetic/soft-era-vim' " 粉色*2
"Plug 'ayu-theme/ayu-vim'      " 赏心悦目的绿色主题
"Plug 'rakr/vim-two-firewatch' " 浅亚麻色
"Plug 'cormacrelf/vim-colors-github' " 据说statuline超好看
"Plug 'edkolev/tmuxline.vim'  " 导出状态栏至tmux

" =====实用插件=====
"Plug 'Lilja/vim-chezmoi'    " :w 提交到 chezmoi
Plug 'github/copilot.vim'
"let g:chezmoi = "disabled"
"Plug 'sheerun/vim-polyglot' " 语言包(包含vim-sensible) 2022-02-20: neovim 暂时不兼容
Plug 'nvim-treesitter/nvim-treesitter' " neovim 的高亮方案
"Plug 'nvim-lua/plenary.nvim' " Some Lua libraries.
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fzf
"Plug 'junegunn/fzf.vim' " fzf.vim
"Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " native telescope sorter
"Plug 'nvim-telescope/telescope.nvim' " fuzzy finder (like fzf)
Plug 'tpope/vim-sensible'    " 我当然是个理智的人
"Plug 'nvim-lua/plenary.nvim' " Required by diffview.nvim
"Plug 'sindrets/diffview.nvim.git' " Better vimdiff!!
"Plug 'RRethy/vim-hexokinase' " 颜色显示
"Plug 'ap/vim-css-color'       " 颜色显示
"Plug 'tpope/vim-endwise'      " 自动结束结构, 与COC冲突???
Plug 'Raimondi/delimitMate'                     " 括号自动补全
Plug 'honza/vim-snippets'     " 代码片段仓库
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'SirVer/ultisnips'      " 代码片段
"Plug 'vimcn/vimcdoc'         " vim中文文档
"Plug 'Valloric/YouCompleteMe', { 'do': 'MAKEFLAGS=12 ./install.py' } " 代码补全
Plug 'terryma/vim-multiple-cursors'             " 多行编辑
Plug 'airblade/vim-gitgutter'                   " git
"Plug 'dense-analysis/ale'                       " 代码异步检测插件
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " 文件管理器
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'jistr/vim-nerdtree-tabs'
Plug 'godlygeek/tabular'                "对齐文本与表格
Plug 'luochen1990/rainbow'              " 彩虹括号
"Plug 'nathanaelkane/vim-indent-guides' " 缩进高亮
"Plug 'Yggdroot/indentLine'              " 缩进线
Plug 'tpope/vim-surround'    " 增强配对符号编辑(快速加括号等), 文本对象s
Plug 'ludovicchabant/vim-gutentags' " Gtag client
Plug 'skywind3000/gutentags_plus'   " 数据库无缝切换
Plug 'skywind3000/asyncrun.vim'     " 异步命令
Plug 'skywind3000/asynctasks.vim'   " 异步tasks
"Plug 'puremourning/vimspector'     " 调试器!!!
Plug 'easymotion/vim-easymotion'    " 快速跳转
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }   " 搜索插件
if $USER != 'root'
	Plug 'lilydjwg/fcitx.vim' " 输入法切换, 需要fcitx-remote
endif
Plug 'dstein64/nvim-scrollview' " 滚动条
"=============== FileType support ===============
Plug 'octol/vim-cpp-enhanced-highlight' " c/cpp highlighting
"Plug 'mboughaba/i3config.vim' "i3配置文件
"Plug 'WolfgangMehner/bash-support'      " Bash, 和 COC 冲突
"Plug 'plasticboy/vim-markdown', { 'for': 'markdown'} " Markdown, in polyglot
"Plug 'vim-latex/vim-latex', { 'for': 'tex'}     " LaTeX支持
"==============COC======================
Plug 'neoclide/coc.nvim', {'branch': 'release'} " 代码补全
"Plug 'repeat.vim'        " 使用.重复命令
"Plug 'christoomey/vim-tmux-navigator' " 与tmux配合
"Plug 'mattn/emmet-vim'   " 前端神器不解释
"Plug 'liuchengxu/vista.vim'  " Viewer & Finder for LSP symbols and tags in Vim
"Plug 'kana/vim-textobj-user' " textobj全家桶, 新增文本对象
"Plug 'kana/vim-textobj-indent'
"Plug 'kana/vim-textobj-syntax'
"Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
"Plug 'sgur/vim-textobj-parameter'
call plug#end()
