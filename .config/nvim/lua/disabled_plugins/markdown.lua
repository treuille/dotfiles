return {
  'MeanderingProgrammer/markdown.nvim',

  -- Honestly, this plugin makes my markdown files look ugly.
  -- Disabling for now.
  enabled = false,

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  ft = { 'markdown' },
  opts = {},
}
