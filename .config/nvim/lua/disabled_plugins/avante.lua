-- This is a new AI plugin I'm playing with

-- Configuration for the plugin
return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false, -- set this if you want to always pull the latest change

  opts = {
    provider = 'claude', -- 'openai',
    -- auto_suggestions_provider = 'copilot',
    providers = {
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-sonnet-4-20250514',
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
    },

    -- openai = {
    --   model = 'gpt-4o',
    -- },
    -- claude = {
    --   model = 'claude-3-5-sonnet-20241022',
    -- },

    -- NOTE: Commented out becuase configuring diretly in zbirenbaum/copilot
    -- behaviour = {
    --   auto_suggestions = true,
    -- }

    hints = {
      enabled = false,
    },
    -- windows = {
    --   height = 20,
    --   position = 'top',
    -- },
  },

  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',

  -- Required plugins to work
  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',

    --- The below dependencies are optional,
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons

    -- -- [optional] for providers='copilot'
    -- 'zbirenbaum/copilot.lua',
  },
}
