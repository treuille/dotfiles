-- Configuration for phaazon/hop.nvim
-- See :h hop

-- The basic idea here is that I want to do quick line jump motions without 
-- 1. Typing in numbers, which is super error prone.
-- 2. Worrying about whether I'm going backwards or forwards. Ever.

---- Create a set of jump keys which are easy to type.
--let s:EasyMotion_keys_1 = 'jfurcm'  " index fingerbb
--let s:EasyMotion_keys_2 = 'hgytnvb' " index finger stretch
--let s:EasyMotion_keys_3 = 'kdie,x'  " middle finger
--let s:EasyMotion_keys_4 = 'lsow.z'  " ring finger
--let s:EasyMotion_keys_5 = ';apq/'   " pinky

---- We add the stretch letters at the end because
---- EasyMotion seems to use these last ones to create the 
---- two-letter motions, and we'd like those to be easier to type.
--let g:EasyMotion_keys = 
--            \ s:EasyMotion_keys_2 . s:EasyMotion_keys_3 .
--            \ s:EasyMotion_keys_4 . s:EasyMotion_keys_5 .
--            \ s:EasyMotion_keys_1

require'hop'.setup()

vim.cmd [[
    map <leader>j <cmd>HopLine<cr>
    map <leader>w <cmd>HopWord<cr>
]]

