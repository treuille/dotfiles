" The COC extentension for telescope doesn't seem to work for now.
" DELETED THIS ON MAC
" lua require('telescope').load_extension('coc')

" Configuration for the telescope fuzzy finder
nnoremap <leader>ff <cmd>Telescope find_files theme=get_dropdown<cr>
nnoremap <leader>fg <cmd>Telescope live_grep theme=get_dropdown<cr>
nnoremap <leader>fb <cmd>Telescope buffers theme=get_dropdown<cr>
nnoremap <leader>fh <cmd>Telescope help_tags theme=get_dropdown<cr>
nnoremap <leader>fi <cmd>Telescope git_files theme=get_dropdown<cr>
nnoremap <leader>fk <cmd>Telescope keymaps theme=get_dropdown<cr>

" Extra cool telescope coc stuff
" nnoremap <leader>fo <cmd>Telescope coc document_symbols theme=get_dropdown<cr>
" nnoremap <leader>fd <cmd>Telescope coc diagnostics theme=get_dropdown<cr>
" nnoremap <leader>fr <cmd>Telescope coc references theme=get_dropdown<cr>

" " Nice find commands for the built-in LSP
" nnoremap <leader>fo <cmd>Telescope lsp_document_symbols theme=get_dropdown<cr>
" nnoremap <leader>fd <cmd>Telescope lsp_document_diagnostics theme=get_dropdown<cr>
" nnoremap <leader>fa <cmd>Telescope lsp_code_actions theme=get_dropdown<cr>
" nnoremap <leader>fr <cmd>Telescope lsp_references theme=get_dropdown<cr>
