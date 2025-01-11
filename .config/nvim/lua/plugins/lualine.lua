return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'auto',
      component_separators = '',
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
      lualine_b = { 'filename', 'branch' },
      lualine_c = {
        '%=', --[[ add your center compoentnts here in place of this comment ]]
      },
      lualine_x = {},
      lualine_y = { 'filetype', 'progress' },
      lualine_z = {
        { 'location', separator = { right = '' }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { 'filename' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
    tabline = {},
    extensions = {},
    -- options = {
    --   icons_enabled = true,
    --   -- theme = 'tokyonight',
    --   theme = 'auto',
    --   component_separators = { '|', '|' },
    --   -- component_separators = {'', ''},
    --   section_separators = { '', '' },
    --   -- section_separators = {'', ''},
    --   disabled_filetypes = {},
    -- },
    -- sections = {
    --   lualine_a = { 'mode' },
    --   lualine_b = { 'branch' },
    --   lualine_c = { 'filename' },
    --   lualine_x = {},
    --   lualine_y = { 'filetype' },
    --   lualine_z = { 'location' },
    -- },
    -- inactive_sections = {
    --   lualine_a = {},
    --   lualine_b = {},
    --   lualine_c = { 'filename' },
    --   lualine_x = { 'location' },
    --   lualine_y = {},
    --   lualine_z = {},
    -- },
    -- tabline = {},
    -- extensions = {},
  },
}
