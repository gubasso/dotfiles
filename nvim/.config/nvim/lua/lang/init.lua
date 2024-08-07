require('lang.rust')

local au = require('core.autocmds')

-- googlescript gs as javascript js
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.gs"},
  command = "set filetype=javascript",
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = au.augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    -- Set spellcheck options
    vim.opt.spell = true
    vim.opt.spelllang = 'en_us'
    -- Hide the colorcolumn 
    vim.opt.colorcolumn = ''
    -- Map the custom command to a keybinding
    vim.api.nvim_set_keymap('n', '<leader>rl', ':RunYTMDLink<CR>', { noremap = true, silent = true })
    vim.keymap.set( 'n', '<LocalLeader>s', ':set spell<cr>',
      { desc =  'Spellcheck set on'})
    vim.keymap.set( 'n', '<LocalLeader>t', ':set spell!<cr>',
      { desc =  'Spellcheck toggle'})
    vim.keymap.set( 'n', '<LocalLeader>p',
      function ()
        vim.opt_local.spelllang = { "pt" }
      end,
      { desc =  'Spelllang pt'})
    vim.keymap.set( 'n', '<LocalLeader>e',
      function ()
        vim.opt_local.spelllang = { "en" }
      end,
      { desc =  'Spelllang en'})
    -- vim.keymap.set(
    --   'n',
    --   '<LocalLeader>t',
    --   '<cmd>wa<CR><cmd>call VimuxRunCommand("doctoc .")<cr>',
    --   { desc =  'Add/Update TOC to all markdown'})
    -- vim.opt_local.spell = true
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = au.augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

