-- Adds the following treesitter-based text objects:
--  * aF : function outer
--  * iF : function inner
--  * aB : block outer
--  * iB : block inner
--  * aC : comment outer
--  * iC : comment inner
--  * aL : loop outer
--  * iL : loop inner
return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              -- Your custom capture.
              -- ["aF"] = "@custom_capture",

              -- Built-in captures.
              ['aF'] = '@function.outer',
              ['iF'] = '@function.inner',
              ['aB'] = '@block.outer',
              ['iB'] = '@block.inner',
              ['aC'] = '@comment.outer',
              ['iC'] = '@comment.inner',
              ['aL'] = '@loop.outer',
              ['iL'] = '@loop.inner',
            },
          },
        },
      }
    end,
  },
}
