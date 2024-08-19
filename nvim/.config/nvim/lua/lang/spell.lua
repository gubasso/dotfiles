local au = require('core.autocmds')
local k = require("which-key").register

vim.api.nvim_create_autocmd("FileType", {
  group = au.augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    -- Set spellcheck options
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
    -- Hide the colorcolumn 
    vim.opt_local.colorcolumn = ''
    -- Map the custom command to a keybinding
    k(
      {
        prefix = "<LocalLeader>",
        name = "Spell",
        l = { ':RunYTMDLink<CR>', 'YTMDLink: YouTube -> Markdown Link' ,noremap = true, silent = true },
        s = {
          function ()
            vim.opt.spell = not vim.o.spell
            print("Spell checking: " .. (vim.o.spell and "ON" or "OFF"))
          end,
          "Toggle spell checking"
        },
        p = {
          function ()
            vim.opt_local.spelllang = { "pt" }
          end,
          "Spelllang pt"
        },
        e = {
          function ()
            vim.opt_local.spelllang = { "en" }
          end,
          "Spelllang en"
        },
      },
      {
        buffer = 0
      }
    )
  end,
})
