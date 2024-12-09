return {
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>ff',
        function()
          -- Disable lsp_fallback because I want precise control over formatting
          require('conform').format { async = true, lsp_fallback = false }
          -- require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 2000,
          -- timeout_ms = 500,
          -- Disable lsp_fallback because I want precise control over formatting
          lsp_fallback = false,
          -- lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },

        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },

        -- For Python, just using black, not isort
        python = { 'black' },

        -- For rust, just using rustfmt, not cargo fmt
        rust = { 'rustfmt' },

        -- For JavaScript and SolidJS, use prettierd
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        html = { 'prettierd' },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        tsx = { 'prettierd' },
        jsx = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        sass = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },

        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
