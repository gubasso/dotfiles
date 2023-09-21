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

local api = vim.api
local M = {}
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        api.nvim_command('augroup '..group_name)
        api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
            api.nvim_command(command)
        end
        api.nvim_command('augroup END')
    end
end



-- vim.keymap.set('i', '<M-e>', '')
-- vim.keymap.set('n', '<M-e>', '')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- required for https://github.com/nvim-tree/nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.nvim_tree_auto_close = true
--
vim.cmd('filetype plugin indent on')
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.signcolumn = 'yes'
vim.opt.signcolumn = 'number'
vim.opt.hidden = true -- " allow [^13] 'E37: No write since last change (add ! to override)'. switch to a different buffer for referencing some code and switch back
vim.opt.pumheight = 10
vim.opt.fileencoding = 'utf-8'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.colorcolumn = '80'
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.timeoutlen = 300
-- vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true -- " ignores case sensitivity by default
vim.opt.smartcase = true --  " no case sensitivity, unless if uppercase character is introduced
vim.opt.showmode = false
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.inccommand = 'split' -- shows search matches (or substitutions matches) in a split window, in real time... live feedback
vim.opt.shortmess:append('c') -- " When searching a for a word, it can be useful to know how many matches there are in the file, like [1/4].
vim.opt.undofile = true
vim.opt.autoread = true

vim.opt.hlsearch = false
vim.opt.incsearch = true


vim.cmd([[
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
augroup auto_checktime
  autocmd!
  " Notify if file is changed outside of vim
  " Trigger `checktime` when files changes on disk
  " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
  " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
          \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
augroup END

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]])

vim.cmd([[
" [Automatically highlight all occurrences of the selected text in visual mode](https://vi.stackexchange.com/questions/20077/automatically-highlight-all-occurrences-of-the-selected-text-in-visual-mode)
" highlight the visual selection after pressing enter.
xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
" Give ctrl+c a job when it is otherwise being wasted!
" Now it toggles `hlsearch` while in NORMAL mode:
nnoremap <silent> <c-c> :if (&hlsearch == 1) \| set nohlsearch \| else \| set hlsearch \| endif<cr>
" Put <enter> to work too! Otherwise <enter> moves to the next line, which we can
" already do by pressing the <j> key, which is a waste of keys!
" Be useful <enter> key!:
nnoremap <silent> <leader><cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
]])

vim.cmd([[
let g:rustfmt_autosave = 1
]])


vim.opt.spelllang = 'en_us'
-- vim.opt.spell = true


require("lazy").setup("plugins")
-- local autoCommands = {
--     -- other autocommands
--     open_folds = {
--         {"BufReadPost,FileReadPost", "*", "normal zR"}
--     }
-- }
-- M.nvim_create_augroups(autoCommands) -- [^1]

-- References:
-- [^1]: https://www.jmaguire.tech/posts/treesitter_folding/
