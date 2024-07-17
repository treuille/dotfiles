-- Useful plugin to show you pending keybinds.
return {
  {
    'folke/which-key.nvim',
    enabled = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key'). add {
        {
          mode = 'n',
          { '<leader>a', group = '[A]I' },
          { '<leader>c', group = '[C]ode' },
          -- { '<leader>d', group = '[D]ocument' },
          { '<leader>f', group = '[F]ormat' },
          { '<leader>h', group = 'Git [H]unk' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>s', group = '[S]earch [S]ymbols' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>w', group = '[W]orkspace' },
        },
        {
          mode = 'v',
          { '<leader>a', group = '[A]I' },
          { '<leader>h', group = 'Git [H]unk' },
        },
      }
    end,
  },
}
