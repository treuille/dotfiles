-- Shared wrapping configuration for multiple filetypes
-- This module provides consistent soft wrapping and hanging indent behavior

local M = {}

-- Apply wrapping settings to the current buffer
function M.setup()
  -- Enable soft wrapping
  vim.opt_local.wrap = true

  -- Break lines at word boundaries
  vim.opt_local.linebreak = true

  -- Enable break indent (hanging indents)
  vim.opt_local.breakindent = true

  -- Indent wrapped lines by 2 spaces
  vim.opt_local.breakindentopt = 'shift:2'

  -- Don't break lines automatically while typing
  vim.opt_local.textwidth = 0

  -- Optional: Show a visual indication of wrapped lines
  vim.opt_local.showbreak = '↪ '

  -- Move by visual lines instead of actual lines
  vim.keymap.set('n', 'j', 'gj', { buffer = true, silent = true })
  vim.keymap.set('n', 'k', 'gk', { buffer = true, silent = true })
  vim.keymap.set('n', 'gj', 'j', { buffer = true, silent = true })
  vim.keymap.set('n', 'gk', 'k', { buffer = true, silent = true })
end

return M
