-- This is a new AI plugin I'm playing with
return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- add any opts here
    provider = 'claude', -- 'openai',
    auto_suggestions_provider = 'copilot',
    openai = {
      model = 'gpt-4o',
    },
    claude = {
      model = 'claude-3-5-sonnet-20241022',
    },
    behaviour = {
      auto_suggestions = true,
    },
    hints = {
      enabled = false,
    },
  },

  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',

  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',

    --- The below dependencies are optional,
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons

    -- [optional] for providers='copilot'
    {
      'zbirenbaum/copilot.lua',
      opts = {
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ['.'] = false,
        },
      },
    },
  },
}
