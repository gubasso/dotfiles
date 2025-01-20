local au = require('core.autocmds')

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
    require("which-key").add({
      { "<LocalLeader>l", ":RunYTMDLink<CR>", desc = "YTMDLink: YouTube -> Markdown Link", noremap = true, silent = true },
      {
        "<LocalLeader>s",
        function()
          vim.opt.spell = not vim.o.spell
          print("Spell checking: " .. (vim.o.spell and "ON" or "OFF"))
        end,
        desc = "Toggle spell checking",
      },
      { "<LocalLeader>p", function() vim.opt_local.spelllang = { "pt" } end, desc = "Spelllang pt" },
      { "<LocalLeader>e", function() vim.opt_local.spelllang = { "en" } end, desc = "Spelllang en" },
    }, { buffer = 0 })

  end,
})
