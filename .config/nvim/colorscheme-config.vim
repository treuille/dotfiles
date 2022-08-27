" Configure lightline
set laststatus=2
set noshowmode

" Make sure that colors look nice
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

if $VIM_THEME == 'light'
    
    " Setup the ayu color scheme
    let ayucolor='light'  " available: light, mirage, dark
    colorscheme ayu

    " Setup the color scheme for lightline
    let g:lightline = {'colorscheme': 'ayu'}

else

    let g:tokyonight_style = 'night' " available: night, storm, day
    let g:tokyonight_transparent = 1
    " let g:tokyonight_enable_italic = 1
    " let g:tokyonight_menu_selection_background = 'red'
    " let g:tokyonight_disable_italic_comment = 1
    colorscheme tokyonight

    " Setup the lightline and airline color schemes
    let g:lightline = {'colorscheme': 'tokyonight'}
    let g:airline_theme = 'tokyonight'

    " Style the highlight column nicely.
    hi ColorColumn guibg=#343A55

    " Nice, subtle Coc type hints
    hi CocRustTypeHint guifg=#272744
    hi CocRustChainingHint guifg=#272744
endif

" ---

" " The old onedark color scheme with darkened background.
" let g:onedark_color_overrides = {
" \ "black": {"gui": "#1C1C1C", "cterm": "235", "cterm16": "0" },
" \ "white": {"gui": "#DEDEDE", "cterm": "145", "cterm16": "7" },
" \}
" colorscheme onedark
" let g:lightline = {'colorscheme': 'onedark'}
