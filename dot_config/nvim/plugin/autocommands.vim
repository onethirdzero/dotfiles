" Yank to WSL clipboard.
" https://waylonwalker.com/vim-wsl-clipboard/
if system('uname -r') =~ "microsoft"
    augroup Yank
        autocmd!
        autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
        augroup END
endif
