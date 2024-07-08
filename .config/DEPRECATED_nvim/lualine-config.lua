if vim.env.VIM_THEME == "LIGHT" then
  lualine_theme = "ayu_light"
else
  lualine_theme = "tokyonight"
end

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = lualine_theme,
        component_separators = {'|', '|'},
        -- component_separators = {'', ''},
        section_separators = {'', ''},
        -- section_separators = {'', ''},
        disabled_filetypes = {}
    },
    -- sections = {
    --     lualine_a = {'mode'},
    --     lualine_b = {'branch'},
    --     lualine_c = {'filename'},
    --     lualine_x = {'encoding', 'fileformat', 'filetype'},
    --     lualine_y = {'progress'},
    --     lualine_z = {'location'}
    -- },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {'filetype'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}

