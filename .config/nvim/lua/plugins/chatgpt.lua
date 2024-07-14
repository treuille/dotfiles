return {
  "jackMort/ChatGPT.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  },
  event = "VeryLazy",
  keys = {
    { '<leader>hh', '<cmd>ChatGPT<CR>', mode = 'n', desc = 'Open ChatGPT Session', },
    { '<leader>hc', '<cmd>ChatGPTCompleteCode<CR>', mode = 'n', desc = "Edit with instruction" },
    { '<leader>he', '<cmd>ChatGPTEditWithInstruction<CR>', mode = 'v', desc = "Edit with instruction" },
    { '<leader>hd', '<cmd>ChatGPTRun docstring<CR>', mode = 'v', desc = "Docstring" },
    { '<leader>ha', '<cmd>ChatGPTRun add_tests<CR>', mode = 'v', desc = "Add Tests" },
    { '<leader>ho', '<cmd>ChatGPTRun optimize_code<CR>', mode = 'v', desc = "Optimize Code" },
    { '<leader>hs', '<cmd>ChatGPTRun summarize<CR>', mode = 'v', desc = "Summarize" },
    { '<leader>hf', '<cmd>ChatGPTRun fix_bugs<CR>', mode = 'v', desc = "Fix Bugs" },
    { '<leader>hx', '<cmd>ChatGPTRun explain_code<CR>', mode = 'v', desc = "Explain Code" },
  },
  cmd = {
    "ChatGPT",
    "ChatGPTActAs",
    "ChatGPTCompleteCode",
    "ChatGPTEditWithInstruction",
    "ChatGPTRun"
  },
  opts = {
    api_key_cmd = 'cat /home/adrien/.config/nvim/chatgpt_nvim.txt',
    popup_input = {
      submit = "<Enter>",
      submit_n = "<C-S-Enter>",
      -- submit = "<C-Enter>",
      -- submit_n = "<Enter>",
    },
    openai_params = {
      model = "gpt-4o",
      -- model = "gpt-4-turbo",
      -- model = "gpt-4-1106-preview",
      frequency_penalty = 0,
      presence_penalty = 0,
      max_tokens = 4095,
      temperature = 0.2,
      top_p = 0.1,
      n = 1,
    },
    openai_edit_params = {
      model = "gpt-4o",
      -- model = "gpt-4-turbo",
      -- model = "gpt-4-1106-preview",
      frequency_penalty = 0,
      presence_penalty = 0,
      max_tokens = 4095,
      temperature = 0.2,
      top_p = 0.1,
      n = 1,
    },
  },
}
