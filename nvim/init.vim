call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions=['coc-omnisharp','coc-python']

call plug#end()

syntax on
set number
set hlsearch
set incsearch
set linebreak
set smartcase
set ignorecase
set relativenumber
set foldmethod=indent
hi Folded ctermbg=none
set clipboard+=unnamedplus
set backspace=indent,eol,start

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

au TermOpen * setlocal nonumber norelativenumber
tnoremap <Esc> <C-\><C-n>
nnoremap <silent> <C-l> <c-w>l
nnoremap <silent> <C-h> <c-w>h
nnoremap <silent> <C-k> <c-w>k
nnoremap <silent> <C-j> <c-w>j

command Vterm :vsp | :terminal
command Sterm :sp | :terminal

vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>

command SortByWidth :'<,'> ! awk '{ print length(), $0 | "sort -n | cut -d\\  -f2-" }'

noremap <Leader>w :w<CR>
