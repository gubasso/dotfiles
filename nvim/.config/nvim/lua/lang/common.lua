local au = require('core.autocmds')

-- https://github.com/mfussenegger/nvim-lint
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})

-- googlescript gs as javascript js
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.gs"},
  command = "set filetype=javascript",
})

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

