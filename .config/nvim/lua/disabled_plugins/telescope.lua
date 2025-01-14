-- NOTE: I have disabled this plugin in favor of `fzf-lua` for the time being.
-- To start using this again, just move this file back into the `plugins` folder.
return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      -- Creates a keymap that opens Telescope with a dropdown theme
      local function dropdown_keymap(keymap, builtin_fn_name, desc, extra_fn_args)
        vim.keymap.set('n', keymap, function()
          -- Default arg just conifgures the dropdown theme
          local fn_args = require('telescope.themes').get_dropdown()

          -- If extra arguments are passed, merge them into the default args
          if extra_fn_args then
            for k, v in pairs(extra_fn_args) do
              fn_args[k] = v
            end
          end

          -- This the funtion we will keymap
          builtin[builtin_fn_name](fn_args)
        end, { desc = desc })
      end
      dropdown_keymap('<leader>sh', 'help_tags', '[S]earch [H]elp')
      dropdown_keymap('<leader>sk', 'keymaps', '[S]earch [K]eymaps')
      dropdown_keymap('<leader>sf', 'find_files', '[S]earch [F]iles')
      dropdown_keymap('<leader>st', 'builtin', '[S]earch Select [T]elescope')
      dropdown_keymap('<leader>sw', 'grep_string', '[S]earch current [W]ord')
      dropdown_keymap('<leader>sg', 'live_grep', '[S]earch by [G]rep')
      dropdown_keymap('<leader>sd', 'diagnostics', '[S]earch [D]iagnostics')
      dropdown_keymap('<leader>sr', 'resume', '[S]earch [R]esume')
      dropdown_keymap('<leader>s.', 'oldfiles', '[S]earch Recent Files ("." for repeat)')
      dropdown_keymap('<leader><leader>', 'buffers', '[ ] Find existing buffers')

      -- Two LSP-baseded keymaps that used to be in `lspconfig.lua`
      dropdown_keymap('<leader>ssd', 'lsp_document_symbols', '[S]earch [S]ymbols [D]ocument')
      dropdown_keymap('<leader>ssf', 'lsp_document_symbols', '[S]earch [S]ymbols [F]unctions', { symbols = 'function' })
      dropdown_keymap('<leader>ssw', 'lsp_dynamic_workspace_symbols', '[S]earch [S]ymbols [W]orkspace')

      -- Old keymaps without the dropdown theme
      -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      -- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      -- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      -- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          -- NOTE: Disabling tranparency because I find it hard to read
          -- winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      -- vim.keymap.set('n', '<leader>sn', function()
      --   builtin.find_files { cwd = vim.fn.stdpath 'config' }
      -- end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
