--       _ ____   _(_)_ __ ___   | |_   _  __ _
--      | '_ \ \ / / | '_ ` _ \  | | | | |/ _` |
--      | | | \ V /| | | | | | |_| | |_| | (_| |
--      |_| |_|\_/ |_|_| |_| |_(_)_|\__,_|\__,_|

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- organization model:
-- https://dev.to/voyeg3r/my-lazy-neovim-config-3h6o
require('core.autocmds')
require('core.options')
require('core.utils')

require"lazy".setup('plugins')

require('lang')

vim.cmd([[
" autocmd CursorHold * echo ''
" secure editing gopass entries
autocmd BufNewFile,BufRead /dev/shm/gopass* setlocal noswapfile nobackup nowritebackup noundofile shada=""
" Ansible [Steps to secure your editor](https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html#vault-securing-editor)
autocmd BufNewFile,BufRead *vault*,~/.ansible/tmp* setlocal noswapfile nobackup nowritebackup noundofile shada=""
]])

-- Define a custom command
vim.api.nvim_create_user_command('RunYTMDLink', function()
  -- Get the current line number and content
  local line = vim.api.nvim_get_current_line()
  -- Extract the URL from the line
  local url = line:match('https?://%S+')
  if url then
    -- Run the external command and capture the output
    local output = vim.fn.system('ytmdlink "' .. url .. '"')
    -- Replace newlines with spaces to keep it on one line
    output = output:gsub("\n", " ")
    -- Replace the URL in the line with the command output
    local new_line = line:gsub(vim.pesc(url), output)
    -- Set the new line content
    vim.api.nvim_set_current_line(new_line)
  else
    print("No URL found in the current line.")
  end
end, { nargs = 0 })
