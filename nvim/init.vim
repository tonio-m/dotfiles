syntax on
set relativenumber
set hlsearch
set incsearch
set linebreak
set smartcase
set ignorecase
"set autoindent
set foldmethod=indent
set backspace=indent,eol,start

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
		    

call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions=['coc-omnisharp','coc-python']
call plug#end()
