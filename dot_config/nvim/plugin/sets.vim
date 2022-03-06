" All the 'set' lines.

set noerrorbells
" Tab and space widths.
set tabstop=4 softtabstop=4
" How many spaces with >> and <<.
set shiftwidth=4
" Convert tabs to spaces.
set expandtab
" Absolute line numbers.
set number
" Combine absolute and relative line numbers.
set relativenumber
" Case-sensitive searching until the first capital letter.
set smartcase
" No swap file mess.
set noswapfile
" Don't let the cursor hit the bottom while scrolling.
set scrolloff=8
" No indent shenanigans when pasting.
set paste

" No backups in favour of a backup directory.
set nobackup
set undodir=~/.vim/undodir
set undofile

" Get results while we search.
set incsearch
" Extra left margin for plugins to flag errors on a specific line.
set signcolumn=yes

" Coloured ruler.
set colorcolumn=80
highlight ColorColumn ctermbg=7 guibg=lightgrey

" Auto save any changes made to a buffer before it's hidden.
set autowrite
