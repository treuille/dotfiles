-- Only load the plugin if the API key exists
local api_key = vim.fn.expand("~/.config/nvim/chatgpt_nvim.txt")
local api_key_exists = vim.fn.filereadable(api_key) == 1

-- Proives a bunch of GenAI tools powered by OpenAI's GPT
return {
  "jackMort/ChatGPT.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  },
  enabled = api_key_exists,
  event = "VeryLazy",
  keys = {
    { '<leader>ah', '<cmd>ChatGPT<CR>', mode = 'n', desc = 'Open ChatGPT Session', },
    { '<leader>ac', '<cmd>ChatGPTCompleteCode<CR>', mode = 'n', desc = "Edit with instruction" },
    { '<leader>ae', '<cmd>ChatGPTEditWithInstruction<CR>', mode = 'v', desc = "Edit with instruction" },
    { '<leader>ad', '<cmd>ChatGPTRun docstring<CR>', mode = 'v', desc = "Docstring" },
    { '<leader>aa', '<cmd>ChatGPTRun add_tests<CR>', mode = 'v', desc = "Add Tests" },
    { '<leader>ao', '<cmd>ChatGPTRun optimize_code<CR>', mode = 'v', desc = "Optimize Code" },
    { '<leader>as', '<cmd>ChatGPTRun summarize<CR>', mode = 'v', desc = "Summarize" },
    { '<leader>af', '<cmd>ChatGPTRun fix_bugs<CR>', mode = 'v', desc = "Fix Bugs" },
    { '<leader>ax', '<cmd>ChatGPTRun explain_code<CR>', mode = 'v', desc = "Explain Code" },
  },
  cmd = {
    "ChatGPT",
    "ChatGPTActAs",
    "ChatGPTCompleteCode",
    "ChatGPTEditWithInstruction",
    "ChatGPTRun"
  },
  opts = {
    api_key_cmd = 'cat ' .. api_key,
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
