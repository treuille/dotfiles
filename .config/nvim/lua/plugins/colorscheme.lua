return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    -- 'folke/tokyonight.nvim',
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'catppuccin-mocha'

      -- NOTE: Below are my old customizations for tokyonight

      -- -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'
      --
      -- -- " Style the highlight column nicely.
      -- vim.cmd.hi 'ColorColumn guibg=#343A55'
      --
      -- -- Nice, subtle Coc type hints
      -- vim.cmd.hi 'CocRustTypeHint guifg=#272744'
      -- vim.cmd.hi 'CocRustChainingHint guifg=#272744'
      --
      -- -- Make unused variables a bit brigher
      -- vim.cmd.hi 'DiagnosticUnnecessary guifg=#737aa2'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
