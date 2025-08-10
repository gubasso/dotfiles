local au = require('core.autocmds')

-- Plugins setup ------------------------------------------------
-- https://github.com/mfussenegger/nvim-lint
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})

-- googlescript -------------------------------------------------
-- gs as javascript js
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.gs"},
  command = "set filetype=javascript",
})

-- Python -------------------------------------------------------
-- Create a new augroup (clears any existing group with the same name)
local jinja2_python = vim.api.nvim_create_augroup("Jinja2Python", { clear = true })
-- Create an autocommand for new or read files matching *.py.jinja2
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = jinja2_python,
  pattern = "*.py.j2",
  callback = function()
    -- Set the filetype to chain Python with Jinja2 syntax highlighting
    vim.bo.filetype = "python.jinja2"
  end,
})

-- Text / Markdown ------------------------------------------
-- Spell
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


-- UX ----------------------------------------------------------
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
    "fugitive",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

