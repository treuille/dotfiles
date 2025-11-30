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
      { '<leader>ssd', '<cmd>FzfLua lsp_document_symbols<cr>', desc = '[S]earch [S]ymbols [D]ocument' },
      { '<leader>ssw', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = '[S]earch [S]ymbols [W]orkspace' },

      -- WARNING: Wasn't able to get this ssf binding to work to find only functions.
      -- {
      --   '<leader>ssf',
      --   function()
      --     require('fzf-lua').lsp_document_symbols {
      --       symbol_handler = function(opts)
      --         -- Filter for function symbols only
      --         opts.symbol_filter = function(sym)
      --           return sym.kind == vim.lsp.protocol.SymbolKind.Function or sym.kind == vim.lsp.protocol.SymbolKind.Method
      --         end
      --         return opts
      --         -- -- require('fzf-lua').lsp_document_symbols { symbols = { 'Function' } }
      --         -- require('fzf-lua').lsp_document_symbols { symbol_kinds = { 'Function' } }
      --         -- -- require('fzf-lua').lsp_document_symbols { symbol_kinds = { 'Function' } }
      --       end,
      --     }
      --   end,
      --   desc = '[S]earch [S]ymbols [F]unctions',
      -- },
    },

    opts = {
      winopts = {
        border = 'rounded', -- 'none', 'single', 'double', 'thicc'
        -- title_pos = 'left',
        -- backdrop = 60,
        treesitter = {
          enabled = true,
          fzf_colors = false,
        },
      },
      preview = {
        border = 'noborder', -- 'border'
      },
      defaults = {
        file_icons = true,
        actions = { ['ctrl-g'] = false },
        cwd_prompt = false,
        toggle_ignore_flag = '--no-ignore', -- flag toggled in `actions.toggle_ignore`
        toggle_hidden_flag = '--hidden', -- flag toggled in `actions.toggle_hidden`
      },
      files = {
        -- Search hidden files such a .zshsrc
        cmd = "rg --files --hidden --follow --glob '!.git/*'",
      },
      -- Not sure why necessary, but suggested by ChatGPT
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git/*'",
      },
    },
  },
}
