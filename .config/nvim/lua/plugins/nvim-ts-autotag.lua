-- Auto-close and rename html tags
return {
  {
    'windwp/nvim-ts-autotag',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },

    -- Filetypes for lazy loading
    ft = { 'html', 'javascriptreact', 'typescriptreact', 'vue', 'xml' },

    -- Setup options
    opts = {
      -- These are the default values
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
    },
  },
}
