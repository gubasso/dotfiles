vim.g.mapleader = ' '
vim.g.maplocalleader = ','
local opt = vim.opt
vim.o.title = true
vim.o.titlestring = "Neovim - %f"
opt.autowrite = true -- Enable auto write
-- vim.opt.clipboard = 'unnamedplus'
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- ignores case sensitivity by default
opt.smartcase = true --  no case sensitivity, unless if uppercase character is introduced
opt.smartindent = true -- Insert indents automatically
opt.inccommand = "nosplit" -- preview incremental substitute, 'split' -- shows search matches (or substitutions matches) in a split window, in real time... live feedback
opt.laststatus = 0
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.signcolumn = 'number'
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.scrolloff = 4 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
-- opt.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.cmd('filetype plugin indent on')
opt.fileencoding = 'utf-8'
opt.colorcolumn = '80'
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.autoread = true
opt.hlsearch = false
opt.incsearch = true


