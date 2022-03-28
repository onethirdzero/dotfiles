nnoremap <CS-e> :NERDTreeToggle<CR>
nnoremap <C-p> :Files<CR>

" Make sure SPACE isn't already mapped to something.
nnoremap <SPACE> <Nop>
let mapleader = " "

" Jump to errors using vim's QuickFix commands.
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>q :cclose<CR>

