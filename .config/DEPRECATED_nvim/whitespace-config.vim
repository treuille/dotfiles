" Creates a keyboard shortut which allows us to see whitepace

" Make it so that `:set list` does something interesting.
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»

nmap <leader>l :set list!<CR>
