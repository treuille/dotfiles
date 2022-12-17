-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Disabled because this is really slow in Pyright, and anyway, 
    -- we're using nvim-cmp. (Normally, this would enable completion
    -- triggered by <c-x><c-o>.)
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- To activate in insert mode, use {"CursorHold", "CursorHoldI"}, instead.

    -- Show line diagnostics automatically in hover window, while preventing
    -- the cursor from getting stuck in the dialog (focusable = false).
    -- See: https://github.com/vh205/dotfiles/blob/master/nvim/lua/lsp-config/init.lua
    vim.o.updatetime = 250
    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local opts = {
              focusable = false,
              close_events = {
                  "BufLeave",
                  "CursorMoved",
                  "InsertEnter",
                  "FocusLost"
              },
              border = 'rounded',
              -- source = 'always',
              -- prefix = ' ',
              -- scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
          end
    })

    -- Always show the sign column so its appearance isn't distracting.
    vim.o.signcolumn = "yes"

    -- Add some pretty colors and sumbols for the diagnostic erros. 
    vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticError", text = ""})
    vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticWarn", text = ""})
    vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticInfo", text = ""})
    vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticHint", text = ""})

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts) 

    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
end


-- Make lsp-config compatible with nvim-cmp.
local client_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities(client_capabilities)


-- Don't show inline virtual text, which I find distracting.
local handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            -- Disable virtual_text
            virtual_text = false
     }
  )
}

-- Setup for various language servers
require('lspconfig')['pyright'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {},
    handlers = handlers,
}

-- TODO: Need to add capabilities and, flags, and handlers 
-- require('lspconfig')['tsserver'].setup{
--     on_attach = on_attach,
--     flags = {},
-- }

-- Use rst-tools instead of require('lspconfig')['rust_analyzer']
require("rust-tools").setup({
    tools = { -- rust-tools options
        autoSetHints = true,
        -- hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = " \u{00B7}\u{00B7} ",
            highlight = "Comment",
            -- highlight = "red",
        },
    },

    -- Args to require('lspconfig')['rust_analyzer'].setup
    server = {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {},
        handlers = handlers,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
})

-- Run rust fmt on save
vim.g.rustfmt_autosave = 1


-- ADRIEN'S OLD STUFF -- 

-- -- Limit lsp diagnostics to show a specific severity in signs column
-- -- See: https://www.reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a/gvd8rb9/
-- -- Capture real implementation of function that sets signs
-- local orig_set_signs = vim.lsp.diagnostic.set_signs
-- local set_signs_limited = function(diagnostics, bufnr, client_id, sign_ns, opts)
--     -- original func runs some checks, which I think is worth doing
--     -- but maybe overkill
--     if not diagnostics then
--         diagnostics = diagnostic_cache[bufnr][client_id]
--     end

--     -- early escape
--     if not diagnostics then
--         return
--     end

--     -- Work out max severity diagnostic per line
--     local max_severity_per_line = {}
--     for _,d in pairs(diagnostics) do
--     if max_severity_per_line[d.range.start.line] then
--       local current_d = max_severity_per_line[d.range.start.line]
--       if d.severity < current_d.severity then
--         max_severity_per_line[d.range.start.line] = d
--       end
--     else
--       max_severity_per_line[d.range.start.line] = djjkk
--     end
--     end

--     -- map to list
--     local filtered_diagnostics = {}
--     for i,v in pairs(max_severity_per_line) do
--         table.insert(filtered_diagnostics, v)
--     end

--     -- call original function
--     orig_set_signs(filtered_diagnostics, bufnr, client_id, sign_ns, opts)
-- end
-- vim.lsp.diagnostic.set_signs = set_signs_limited

