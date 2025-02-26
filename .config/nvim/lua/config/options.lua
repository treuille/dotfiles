-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- To disable the clipboard integration and ensure the most performant setting, can use:
-- Disable clipboard integration
vim.opt.clipboard = ''

-- Prevent loading the clipboard provider plugin
-- See `:help 'clipboard'`
vim.g.loaded_clipboard = 1

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
-- vim.opt.timeoutlen = 300

-- Decrease delay when going from INSERT -> NORMAL mode
-- See :h 'ttimeoutlen'
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 1

-- Use spaces not tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Encourage an 88 character width column for `gq`.
-- vim.opt.colorcolumn = "88"
vim.opt.textwidth = 88

-- Prevent line wrapping
vim.opt.wrap = false

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Enable auto-reloading of changed files
vim.o.autoread = true -- Enable auto-reloading of changed files
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'BufWinEnter', 'CursorHold' }, {
  pattern = '*',
  command = 'checktime', -- Checks if the file has changed and reloads it
})

-- vim: ts=2 sts=2 sw=2 et
