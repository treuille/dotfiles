-- Unofficial GitHub Copilot plugin
return {
  {
      "zbirenbaum/copilot.lua",
      opts = {
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>",
            -- accept = "<C-y>",
            -- accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-n>",
            -- dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        server_opts_overrides = {},
      },
      cmd = "Copilot",
      event = "InsertEnter",
  },
}
