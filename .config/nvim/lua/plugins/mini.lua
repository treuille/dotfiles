return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',

    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Some text manipulation operators
      -- g= - Evaluate text and replace with output
      -- gx - Exchange text regions
      -- gm - Multiply (duplicate) text
      -- gr - Replace text with register
      -- gs - Sort text
      require('mini.operators').setup()

      -- Work with trailing whitespace
      require('mini.trailspace').setup()

      -- Make nice auto-paired parentheses
      require('mini.pairs').setup()
    end
  }
}
