-- Useful plugin to show you pending keybinds.
return {
  {
    'folke/which-key.nvim',
    enabled = false,
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
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk' },
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
