" Configuration for the telescope fuzzy finder
nnoremap <leader>ff <cmd>Telescope find_files theme=get_dropdown<cr>
nnoremap <leader>fg <cmd>Telescope live_grep theme=get_dropdown<cr>
nnoremap <leader>fb <cmd>Telescope buffers theme=get_dropdown<cr>
nnoremap <leader>fh <cmd>Telescope help_tags theme=get_dropdown<cr>
nnoremap <leader>fi <cmd>Telescope git_files theme=get_dropdown<cr>
nnoremap <leader>fk <cmd>Telescope keymaps theme=get_dropdown<cr>
nnoremap <leader>fo <cmd>Telescope lsp_document_symbols theme=get_dropdown<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics theme=get_dropdown bufnr=0<cr>

" " Nice find commands for the built-in LSP
" nnoremap <leader>fa <cmd>Telescope lsp_code_actions theme=get_dropdown<cr>
" nnoremap <leader>fr <cmd>Telescope lsp_references theme=get_dropdown<cr>
