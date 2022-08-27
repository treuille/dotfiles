" This was for the old a-vrma/black-nvim
" nnoremap <leader>b <cmd>call Black()<cr>

let g:black_virtualenv = $VIRTUAL_ENV
nnoremap <leader>b <cmd>Black<cr>
autocmd BufWritePre *.py execute ':Black'
