return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'vim',
        'vimdoc',
        'gitcommit',
      },
      -- Autoinstall languages that are not installe
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages epend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },

      -- Enable incremental selection of treesitter objects
      incremental_selection = {
        enable = true,
        keymaps = {
          -- see the config() function below to see where the keymaps are set
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup(opts)

      local incremental_selection = require 'nvim-treesitter.incremental_selection'
      vim.keymap.set('n', '<C-Space>', incremental_selection.init_selection, { desc = '[V]isually select treesitter node' })
      vim.keymap.set('x', '<C-j>', incremental_selection.node_incremental, { desc = 'Increment treesitter selection' })
      vim.keymap.set('x', '<C-k>', incremental_selection.node_decremental, { desc = 'Shrink selection to previous named node' })

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
