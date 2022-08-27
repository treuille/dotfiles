" These are the final overrides over any keybindings described in previous config files.

" Turn off search highlighing.
nnoremap <leader>n :noh<cr>

" Allow you to paste in into the visual selection without losing the yank register
" According to ThePrimeagen, the best remap ever: https://youtu.be/Q5eDxR7bU2k?t=256
vnoremap <leader>p "_dP

" Allows me to save buffers without contorting my fingers.
nnoremap <leader>s :update<cr>

" Allows me to replace the selected text, without contorting my fingers either.
" See: https://stackoverflow.com/questions/676600/vim-search-and-replace-selected-text
vnoremap <leader>r "hy:%s/<C-r>h//gc<left><left><left>
