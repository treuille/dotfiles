-- Quickly move throughout the buffer by "hopping"
return {
    {
        'smoka7/hop.nvim',
        opts = {
            -- keys = 'etovxqpdygfblzhckisuran'
        },
        keys = {
            {
                '<leader>j',
                '<cmd>HopLine<cr>',
                mode = 'n',
                desc = 'Hop to a line',
            },
            {
                '<leader>w',
                '<cmd>HopWord<cr>',
                mode = 'n',
                desc = 'Hop to a word',
            },
        },
    }
}
