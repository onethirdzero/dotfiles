syntax on

" # Plugins.
call plug#begin()

Plug 'gruvbox-community/gruvbox'
" Git integration.
Plug 'tpope/vim-fugitive'
" View man pages in vim.
Plug 'vim-utils/vim-man'
" Use the fzf package installed by the host package manager.
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
" Side bar file explorer.
Plug 'preservim/nerdtree'
" Smooth scrolling.
Plug 'psliwka/vim-smoothie'
" Golang support.
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
" Switch between single line and multiline code.
Plug 'AndrewRadev/splitjoin.vim'

call plug#end()

colorscheme gruvbox
