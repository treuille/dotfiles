syntax on

" Relative line numbers
set number relativenumber

" ABC -123 
" Some keyboard mappings using spacebar as the leader.
let mapleader = "\<Space>"

" Relative line numbe
:set nu rnu
   
" Decrease delay when going from INSERT -> NORMAL mode
" See :h 'ttimeoutlen'
set timeoutlen=1000 ttimeoutlen=1

" Use spaces not tabs
set tabstop=4 shiftwidth=4 expandtab

" Encourage an 88 character width column for `gq`.
set colorcolumn=88 textwidth=88

" Prevent line wrapping
set nowrap

" " Enable mouse input in supporting terminals (like iTerm2 and Blink)
" set mouse=a

" Setup junegunn/vim-plug
call plug#begin('~/.local/share/nvim/vim-plug')

" Adrien's favorite new color scheme
Plug 'folke/tokyonight.nvim'      " <- main color scheme

" " Not-as-dark theme
Plug 'ayu-theme/ayu-vim'
Plug 'yarisgutierrez/ayu-lightline'

" JST/TSX syntax highlighting
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" TOML syntax highlighting
Plug 'cespare/vim-toml'

" Do fuzzy finding with telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Language Server Protocol support
" See: https://www.youtube.com/watch?v=tOjVHXaUrzo
Plug 'neovim/nvim-lspconfig'

" Autocomplete using LSP
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Using LuaSnip for completions
Plug 'L3MON4D3/LuaSnip', {'tag': 'v1.*'}

" Not using this because it's no longer supported..
" Plug 'nvim-lua/completion-nvim'

" Make commenting un-super-annoying (per Thiago's suggestio)
Plug 'tpope/vim-commentary'

" Give us some surround amazingness
Plug 'tpope/vim-surround'

"Nice syntax highlighting 
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Status line
" Plug 'itchyny/lightline.vim'
" Plug 'vim-airline/vim-airline'
Plug 'hoob3rt/lualine.nvim'

" Enables nice icons in lualine. See github.com/hoob3rt/lualine.nvim
Plug 'kyazdani42/nvim-web-devicons'

" Trying easymotion instead for vertical and horizontal motion
" Plug 'easymotion/vim-easymotion'
Plug 'phaazon/hop.nvim'

" Enable black to work where installed
Plug 'psf/black', { 'branch': 'stable' }

" Enable Github Copilot
Plug 'github/copilot.vim'

" Following https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/
Plug 'williamboman/mason.nvim'    
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'simrat39/rust-tools.nvim'
Plug 'rust-lang/rust.vim'

" Initialize plugin system
call plug#end()


source  ~/.config/nvim/colorscheme-config.vim
luafile ~/.config/nvim/lsp-config.lua
luafile ~/.config/nvim/nvim-cmp-config.lua
source  ~/.config/nvim/commentary-config.vim
luafile ~/.config/nvim/hop-config.lua
source  ~/.config/nvim/telescope-config.vim
source  ~/.config/nvim/whitespace-config.vim
source  ~/.config/nvim/black-config.vim
luafile ~/.config/nvim/lualine-config.lua
source  ~/.config/nvim/keybindings-config.vim
luafile ~/.config/nvim/treesitter-config.lua
luafile ~/.config/nvim/mason-config.lua
