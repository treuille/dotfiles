# Adrien's neovim config

This is based on [dam9000/kickstart](https://github.com/dam9000/kickstart-modular.nvim) with the following changes

* Removed mason because I prefer to intall LSPs in the local virtual environment.
* Adding in some of my own favorite plugins like hop.

## Todo 

* Continue manually going through all plugins to see if I want them

* Add in my own commenting plugin -- or just use the neovim v0.10 commenting

* Add lspconfig support
    * See if there's a good formatting plugin I can add here

* Go through my old plugins 
    * `hoob3rt/lualine.nvim`
    * `phaazon/hop.nvim`
    * `github/copilot.vim`
    * `williamboman/mason.nvim`
    * `williamboman/mason-lspconfig.nvim`
    * maybe later
        * `tpope/vim-surround`
        * `psf/black`

* Go through my old neovim config and add things that I liked
    * Keybindings
        * `<leader>p` - nice paste thing
        * `<leader>w` - nice write things
* Do I really want this which-key thing? 
* Test that Python coding is working nicely
* install LuaRocks? `sudo apt install liblua5.1-0-dev`

## Later

* Install Rust plugins
    * `simrat39/rust-tools.nvim`
    * `rust-lang/rust.vim`
* Typescript stuff?
    * `leafgarland/typescript-vim`
    * `peitalin/vim-jsx-typescript`
* TOML stuff?
    * `cespare/vim-toml`
* LUA stuff?
    * `L3MON4D3/LuaSnip`
