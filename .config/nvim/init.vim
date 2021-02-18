" SECTION - PLUGINS
call plug#begin()
Plug 'jeetsukumaran/vim-buffergator'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()

let g:coc_global_extensions=[
\  'coc-omnisharp',
\  'coc-python',
\  'coc-json',
\  'coc-go'
\]

" SECTION - TABS
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" SECTION - EDITOR
syntax on
set number
set hlsearch
set incsearch
set linebreak
set smartcase
set noswapfile
set ignorecase
set relativenumber
set foldmethod=indent
set clipboard=unnamedplus
set backspace=indent,eol,start

" SECTION - TERMINAL
au TermOpen * setlocal nonumber norelativenumber

" SECTION - REMAPS
nnoremap S diw"0P
tnoremap <Esc> <C-\><C-n>
noremap <silent> <C-l> <c-w>l
noremap <silent> <C-h> <c-w>h
noremap <silent> <C-k> <c-w>k
noremap <silent> <C-j> <c-w>j
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap Y y$

" SECTION - COMMANDS
command Sterm :sp | :terminal
command Vterm :vsp | :terminal
command -range SortByWidth :<line1>,<line2>! awk '{ print length(), $0 | "sort -n | cut -d\\  -f2-" }'
command -nargs=1 SetTabSize call SetTabSize(<f-args>)
command! -nargs=1 SaveBuffers call SaveBuffers(<f-args>) 

" SECTION - COLORS
hi Folded ctermbg=none
hi Folded ctermfg=gray

" SECTION - FUNCTIONS
function SetTabSize(n)
  let &l:tabstop=a:n
  let &l:shiftwidth=a:n
  let &l:softtabstop=a:n
endfunction
