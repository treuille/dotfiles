-- This is a replacement for telescope which I'm playing with.
return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    keys = {
      -- { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },

      { '<leader>sf', '<cmd>FzfLua files<cr>', desc = '[S]earch [F]iles' },
      { '<leader>sh', '<cmd>FzfLua helptags<cr>', desc = '[S]earch [H]elp' },
      { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = '[S]earch [K]eymaps' },
      { '<leader>sb', '<cmd>FzfLua builtin<cr>', desc = '[S]earch [B]uiltin FzfLua Commands' },
      { '<leader>sw', '<cmd>FzfLua grep_cword<cr>', desc = '[S]earch current [W]ord' },
      { '<leader>sg', '<cmd>FzfLua live_grep<cr>', desc = '[S]earch by [G]rep' },
      { '<leader>sdd', '<cmd>FzfLua lsp_document_diagnostics<cr>', desc = '[S]earch [D]iagnostics [D]ocument' },
      { '<leader>sdw', '<cmd>FzfLua lsp_orkspace_diagnostics<cr>', desc = '[S]earch [D]iagnostics [W]orkspace' },
      { '<leader>sr', '<cmd>FzfLua resume<cr>', desc = '[S]earch [R]esume' },
      { '<leader>s.', '<cmd>FzfLua oldfiles<cr>', desc = '[S]earch Recent Files ("." for repeat)' },
      { '<leader><leader>', '<cmd>FzfLua buffers<cr>', desc = '[ ] Find existing buffers' },
      -- { '<leader>ssd', '<cmd>FzfLua lsp_document_symbols<cr>', desc = '[S]earch [S]ymbols [D]ocument' },
      {
        '<leader>ssd',
        function()
          require('fzf-lua').lsp_document_symbols { fzf_cli_args = '--with-nth 1..' }
        end,
        desc = '[S]earch [S]ymbols [D]ocument',
      },
      { '<leader>ssw', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = '[S]earch [S]ymbols [W]orkspace' },
      {
        '<leader>ssf',
        function()
          require('fzf-lua').lsp_document_symbols {
            symbol_handler = function(opts)
              -- Filter for function symbols only
              opts.symbol_filter = function(sym)
                return sym.kind == vim.lsp.protocol.SymbolKind.Function or sym.kind == vim.lsp.protocol.SymbolKind.Method
              end
              return opts
              -- -- require('fzf-lua').lsp_document_symbols { symbols = { 'Function' } }
              -- require('fzf-lua').lsp_document_symbols { symbol_kinds = { 'Function' } }
              -- -- require('fzf-lua').lsp_document_symbols { symbol_kinds = { 'Function' } }
            end,
          }
        end,
        desc = '[S]earch [S]ymbols [F]unctions',
      },
    },

    opts = {},
  },
}

--       -- Old keymaps without the dropdown theme
--       -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
--       -- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
--       -- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
--       -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
--       -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
--       -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
--       -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
--       -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
--       -- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
--       -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
--
--       -- Slightly advanced example of overriding default behavior and theme
--       vim.keymap.set('n', '<leader>/', function()
--         -- You can pass additional configuration to Telescope to change the theme, layout, etc.
--         builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--           -- NOTE: Disabling tranparency because I find it hard to read
--           -- winblend = 10,
--           previewer = false,
--         })
--       end, { desc = '[/] Fuzzily search in current buffer' })
--
--       -- It's also possible to pass additional configuration options.
--       --  See `:help telescope.builtin.live_grep()` for information about particular keys
--       vim.keymap.set('n', '<leader>s/', function()
--         builtin.live_grep {
--           grep_open_files = true,
--           prompt_title = 'Live Grep in Open Files',
--         }
--       end, { desc = '[S]earch [/] in Open Files' })
