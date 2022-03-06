" # Plugins.
call plug#begin()

Plug 'gruvbox-community/gruvbox'
" Git integration.
Plug 'tpope/vim-fugitive'
" View man pages in vim.
Plug 'vim-utils/vim-man'
" Fuzzy file finding. The hook keeps it up to date.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Side bar file explorer.
Plug 'preservim/nerdtree'

call plug#end()

colorscheme gruvbox
