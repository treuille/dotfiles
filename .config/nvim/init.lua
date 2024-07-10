-- Set <space> as the leader key
-- NOTE: Must do before loading plugins or wrong leader will be used
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require 'config.options'

-- [[ Basic Keymaps ]]
require 'config.keymaps'

-- [[ Install and run `lazy.nvim` plugin manager ]]
require 'config.lazy'
