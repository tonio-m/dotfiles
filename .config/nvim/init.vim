call plug#begin()
" Plug 'jeetsukumaran/vim-buffergator'
" Plug 'neovim/nvim-lspconfig'
" Plug 'sindrets/diffview.nvim'
Plug 'monsonjeremy/onedark.nvim'
call plug#end()

lua << EOF
require('onedark').setup()
-- require'lspconfig'.pyright.setup{}
EOF


" EDITOR "
syntax on
set nowrap
set number
set hlsearch
set expandtab
set incsearch
set linebreak
set smartcase
set tabstop=4
set ignorecase
set noswapfile
set shiftwidth=4
set softtabstop=4
set relativenumber
set foldmethod=indent
set clipboard=unnamedplus
set backspace=indent,eol,start

hi Folded ctermbg=none
hi Folded ctermfg=gray

nnoremap Y y$
noremap <silent> <C-h> <C-w>h
noremap <silent> <C-j> <C-w>j
noremap <silent> <C-k> <C-w>k
noremap <silent> <C-l> <C-w>l
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>

"" netrw "
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_maxfilenamelen=66

" terminal "
tnoremap <Esc><Esc> <C-\><C-n>
au TermOpen * setlocal nonumber norelativenumber

" commands "
command Sterm :sp | :terminal
command Vterm :vsp | :terminal
command! -nargs=* Nn call Nn(<f-args>)
command Vault :e ~/Obsidian/marco_vault/000_inbox/
command -nargs=1 SetTabSize call SetTabSize(<f-args>)
" command! -nargs=1 SaveBuffers call SaveBuffers(<f-args>) "
command! In execute 'cd $HOME/obsidian/marco_vault | Explore ./000_inbox/'
command! Va execute 'cd $HOME/obsidian/marco_vault | Explore ./003_vault/'
command! Jo execute 'cd $HOME/obsidian/marco_vault | Explore ./001_journal/'
command! -nargs=? Wn execute 'lcd $HOME/obsidian/marco_vault | call s:OpenOrCreateJournal(<f-args>)'
command -range SortByWidth :<line1>,<line2>! awk '{ print length(), $0 | "sort -n | cut -d\\  -f2-" }'
command! Dn execute "lcd $HOME/obsidian/marco_vault | edit 001_journal/" . strftime("%Y-%m-%d") . ".md"

" functions "
function SetTabSize(n)
  let &l:tabstop=a:n
  let &l:shiftwidth=a:n
  let &l:softtabstop=a:n
endfunction

function! Nn(...)
  execute 'cd $HOME/Obsidian/marco_vault/000_inbox/'
  let current_time = strftime("%Y-%m-%dT%H:%M:%S%z")
  if a:0 == 0
    execute 'edit '.current_time.'.md'
  else
    let filename = join(a:000, ' ').'.md'
    execute 'edit '.filename
  endif
endfunction

function! s:OpenOrCreateJournal(...) abort
  let l:offset = a:0 > 0 ? a:1 : 0
  let l:week_num = strftime('%V') + l:offset
  let l:year = strftime('%Y')
  if l:week_num < 1
    let l:week_num = 52 + l:week_num
    let l:year = l:year - 1
  elseif l:week_num > 52
    let l:week_num = l:week_num - 52
    let l:year = l:year + 1
  endif
  let l:filename = '001_journal/' . l:year . '-W' . printf('%02d', l:week_num) . '.md'
  if !filereadable(l:filename)
    call writefile([
          \ 'sun:',
          \ '[[001_journal/' . strftime('%Y-%m-%d', localtime() + (0 - strftime('%w')) * 86400 + l:offset * 604800) . '.md]]',
          \ '',
          \ 'mon:',
          \ '[[001_journal/' . strftime('%Y-%m-%d', localtime() + (1 - strftime('%w')) * 86400 + l:offset * 604800) . '.md]]',
          \ '',
          \ 'tue:',
          \ '[[001_journal/' . strftime('%Y-%m-%d', localtime() + (2 - strftime('%w')) * 86400 + l:offset * 604800) . '.md]]',
          \ '',
          \ 'wed:',
          \ '[[001_journal/' . strftime('%Y-%m-%d', localtime() + (3 - strftime('%w')) * 86400 + l:offset * 604800) . '.md]]',
          \ '',
          \ 'thu:',
          \ '[[001_journal/' . strftime('%Y-%m-%d', localtime() + (4 - strftime('%w')) * 86400 + l:offset * 604800) . '.md]]',
          \ '',
          \ 'fri:',
          \ '[[001_journal/' . strftime('%Y-%m-%d', localtime() + (5 - strftime('%w')) * 86400 + l:offset * 604800) . '.md]]',
          \ '',
          \ 'sat:',
          \ '[[001_journal/' . strftime('%Y-%m-%d', localtime() + (6 - strftime('%w')) * 86400 + l:offset * 604800) . '.md]]',
          \ ''
          \ ], l:filename)
  endif
  execute 'edit ' . l:filename
endfunction

