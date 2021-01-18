" SECTION - PLUGINS
call plug#begin()
Plug 'jeetsukumaran/vim-buffergator'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

let g:coc_global_extensions=[
\  'coc-omnisharp',
\  'coc-python',
\  'coc-json'
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
command -nargs=1 MarkdownPreview sp | term pandoc <f-args> | lynx -stdin
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

function! SaveBuffers(folder)
    call mkdir(a:folder, "p", 0700)
    let bufferList = range(1,bufnr('$'))
    call filter(bufferList, 'buflisted(v:val)')
    execute 'sp'
    for i in bufferList
        execute 'bNext'
        execute 'w ' . a:folder . '/' . i . '.' . &ft
    endfor
    execute 'q'
endfunction
