" __     ___           ____   ____
" \ \   / (_)_ __ ___ |  _ \ / ___|
"  \ \ / /| | '_ ` _ \| |_) | |
"   \ V / | | | | | | |  _ <| |___
"    \_/  |_|_| |_| |_|_| \_\\____|

""""""""""""
" vim-plug "
""""""""""""
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'vim-scripts/BufOnly.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'rbong/vim-flog'
Plug 'mattn/emmet-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'pangloss/vim-javascript'
Plug 'cespare/vim-toml'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'wellle/targets.vim'
Plug 'jesseleite/vim-agriculture'
Plug 'kovetskiy/sxhkd-vim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'rbong/vim-flog'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'justinmk/vim-dirvish'

" Themes
" Plug 'sickill/vim-monokai'
" Plug 'phanviet/vim-monokai-pro'
" Plug 'patstockwell/vim-monokai-tasty'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end() " [^1]
"""""""""""""""""""""""""""
"""""""""""""""""""""""""""
"""""""""""""""""""""""""""

"""""""""""""""
" Basic Setup "
"""""""""""""""
set relativenumber
set number                  " Set current line number with others relative numbers
set expandtab               " Insert spaces when TAB is pressed.
set tabstop=4 softtabstop=4 " Render TABs using this many spaces.
set shiftwidth=4            " Indentation amount for < and > commands.
set inccommand=split        " shows search matches (or substitutions matches) in a split window, in real time... live feedback
set list
set list lcs=tab:\|\ ,trail:-

set encoding=utf-8
set hidden " allow [^13] 'E37: No write since last change (add ! to override)'. switch to a different buffer for referencing some code and switch back
set ignorecase " ignores case sensitivity by default
set smartcase " no case sensitivity, unless if uppercase character is introduced
set splitright " To make vsplit put the new buffer on the right of the current buffer:
set splitbelow " Similarly, to make split put the new buffer below the current buffer:
set noswapfile
set undodir=~/.cache/nvim/undodir
set undofile
set termguicolors
set colorcolumn=80
set nobackup
set nowritebackup
set shortmess-=S " When searching a for a word, it can be useful to know how many matches there are in the file, like [1/4].
set scrolloff=8
set sidescrolloff=8

let g:vim_monokai_tasty_italic = 1
" colorscheme vim-monokai-tasty
" colorscheme monokai
" colorscheme monokai_pro
" colorscheme tender
colorscheme dracula

hi link markdownError Normal " [^6]

set autoread " Autoload file changes. You can undo by pressing u. [^11]
" Triger `autoread` when files changes on disk [^11]
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Netwr: native file explorer in vim
let g:netrw_liststyle=3 " Tree style
let g:netrw_banner = 0 " Removing the banner. To toggle press `I`.


" Automatically reload vimrc upon save [^4]
if has('autocmd') " ignore this section if your vim does not support autocommands
    augroup reload_vimrc
        autocmd!
        autocmd! BufWritePost $MYVIMRC,$MYGVIMRC nested source %
    augroup END
endif

" Redir output to empty buffer [^5]
command! -nargs=+ -complete=command Redir let s:reg = @@ | redir @"> | silent execute <q-args> | redir END | new | pu | 1,2d_ | let @@ = s:reg

" editorconfig [^7]
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*'] " exclude pattern
au FileType gitcommit let b:EditorConfig_disable = 1 " disable EditorConfig for all git commit messages (filetype gitcommit)
" au FileType markdown let b:EditorConfig_disable = 1
" let g:EditorConfig_verbose=1

" auto create docs markdown helpers
augroup mdhelpers
    au!
    "" reference structure with a sequence number
    au FileType markdown nnoremap <leader>ri o[^1]: []()"+pT)
    au FileType markdown nnoremap <leader>rs :norm 0ll:let @n=0"nyiwo[^=n+1]: []()"+pT)
    "" code block: simple
    au FileType markdown nnoremap <leader>cc o``````kk
    au FileType markdown nnoremap <leader>cp o``````kk"+p
    "" code block: with file name
    au FileType markdown nnoremap <leader>ff o**``**``````kkkklll
    au FileType markdown nnoremap <leader>fp o**``**``````kk"+p
    "" link and paste at end
    au FileType markdown nnoremap <leader>i i[]()"+pT)
augroup END

augroup mdfiletypes
    " associate *.foo with bar filetype
    " do not override previouslly setted filetypes
    au!
    au BufNewFile,BufRead *.rmd setfiletype markdown
    au BufNewFile,BufRead Description setfiletype markdown
augroup END

" FZF Rg[^3]
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" au! BufNewFile,BufRead *.marko set ft=html

" Svelte [^8]
" unabled due to 'evanleck/vim-svelte' plugin
au! BufNewFile,BufRead *.svelte set ft=html
" tpope/vim-commentary [^12]
autocmd FileType svelte setlocal commentstring=<!--%s-->

" https://github.com/christoomey/vim-tmux-navigator
" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" sxhkd, refresh keybindings
autocmd BufWritePost *sxhkdrc !killall sxhkd; setsid sxhkd &




"""""""""""""""""""""""""""""
" Keymappings / Keybindings "
"""""""""""""""""""""""""""""

let mapleader="\<space>" " set the leader key as <space> in normal mode... to then run my own key shortcuts
" highlight the visual selection after pressing enter.[^15]
xnoremap <silent> <leader><cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
" Give ctrl+c a job when it is otherwise being wasted![^15]
" Now it toggles `hlsearch` while in NORMAL mode:
nnoremap <silent> <c-c> :if (&hlsearch == 1) \| set nohlsearch \| else \| set hlsearch \| endif<cr>
" Put <enter> to work too! Otherwise <enter> moves to the next line, which we can
" already do by pressing the <j> key, which is a waste of keys!
" Be useful <enter> key!:
nnoremap <silent> <leader><cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
" Edit vimr configuration file
nnoremap <Leader>ve :e $MYVIMRC<CR>
" Automatically reload vimrc upon save [^4]
if has('autocmd') " ignore this section if your vim does not support autocommands
    augroup reload_vimrc
        autocmd!
        autocmd! BufWritePost $MYVIMRC,$MYGVIMRC nested source %
    augroup END
endif
nnoremap  Y  y$
" Buffer manipulation
nnoremap <leader><Tab> :b#<CR>
nnoremap <leader>q :bd!<cr>
nnoremap <leader>b :Buffers<CR>
" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy
" Cut to clipboard
vnoremap  <leader>d  "+ygvd
nnoremap  <leader>D  "+yg_dg_
nnoremap  <leader>d  "+d
nnoremap  <leader>dd  "+yydd
" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P<Paste>
" FZF: Insert mode completion
imap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd --hidden --follow --exclude .git')
imap <c-x><c-l> <plug>(fzf-complete-line)
inoremap <expr> <c-x><c-i> fzf#vim#complete(fzf#wrap({
  \ 'prefix': '^.*$',
  \ 'source': 'rg -n ^ --color always',
  \ 'options': '--ansi --delimiter : --nth 3..',
  \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }})) " [^2]
" FZF
nnoremap <C-p> :Files!<CR>
nnoremap <C-f> :RG!<CR>
nnoremap <leader>l :RG!<CR>
nnoremap <C-q>f :History<CR>
nnoremap <C-q>c :History:<CR>
nnoremap <C-q>s :History/<CR>
" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Vimux config
let g:VimuxOrientation = "v"
let g:VimuxHeight = "40"

function! VimuxInspectGoTop()
  call VimuxInspectRunner()
  call VimuxSendKeys("g")
endfunction
command -bar VimuxInspectGoTop :call VimuxInspectGoTop()

function! VimuxZoomAndInspectGoTop()
  call VimuxZoomRunner()
  call VimuxInspectGoTop()
endfunction
command -bar VimuxZoomAndInspectGoTop :call VimuxZoomAndInspectGoTop()

" move by one line[^16]
" nnoremap j gj
" nnoremap k gk

" Goyo and Limelight[^17]
nnoremap <Leader>gy :Goyo<CR>
nnoremap <Leader>ll :Limelight!!<CR>
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
let g:limelight_conceal_ctermfg = 240

" Dev Workflow with Vimux
" Prompt for a command to run [^10]
nnoremap <leader>vp :wa<cr> \| :VimuxPromptCommand<cr>
" Run last command executed by VimuxRunCommand [^10]
nnoremap <leader>vl :wa<cr> \| :VimuxRunLastCommand<cr>
" Inspect runner pane [^10]
nnoremap <leader>vi :VimuxInspectGoTop<cr>
" Zoom the tmux runner pane[^10]
nnoremap <leader>vz :VimuxZoomAndInspectGoTop<CR>
" Rust workflow
" nnoremap <leader>cc :silent Redir !cargo clippy --all-targets --tests<cr>
" nnoremap <leader>ct :silent Redir !cargo test<cr>G
" nnoremap <leader>cf :silent !rustfmt %<cr>
" nnoremap <leader>cp :silent Redir !cargo play %<cr>
" call any command [^13]

augroup rust_work
    au!
    au FileType rust nnoremap <Leader>r :wa<cr> \| :VimuxPromptCommand("clrm; cargo ")<CR>
    au FileType rust nnoremap <Leader>t :wa<cr> \| :call VimuxRunCommand("clrm; cargo test -- --nocapture")<CR>
    au FileType rust nnoremap <Leader>c :wa<cr> \| :call VimuxRunCommand("clrm; cargo clippy")<CR>
augroup END

" gopass security: https://github.com/gopasspw/gopass/blob/master/docs/setup.md#securing-your-editor
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile

" Easy Align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)


" Spell
set spelllang=en_us

filetype plugin indent on
syntax enable

""""""""""""""""""""
" Inactive Options "
""""""""""""""""""""

" hi Normal guibg=#111111 ctermbg=black
" hi! Normal ctermbg=NONE guibg=NONE " Keep terminal background
" hi Normal guibg=#111111 ctermbg=black
" highlight Normal ctermbg=black
" highlight NonText ctermbg=black

" Swapfiles
" Centralised swapfiles
" Make swapfiles be kept in a central location to avoid polluting file system:
" set directory^=$HOME/.config/nvim/swapfiles//


""""""""""""""
" References "
""""""""""""""

" [^1]: Automatically executes
" `filetype plugin indent` on and
" `syntax enable`.
" You can revert the settings after the call. e.g. filetype indent off, syntax off, etc. (https://github.com/junegunn/vim-plug#usage)

" [^2]:  Global line completion (not just open buffers. ripgrep required.) (https://github.com/junegunn/fzf.vim#custom-completion)

" [^3]: Example: Advanced ripgrep integration (https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration)
"
" [^4]: Automatically reload vimrc upon save (https://riptutorial.com/vim/example/20644/automatically-reload-vimrc-upon-save)
"
" [^5]: Dump the output of internal vim command into buffer (https://vi.stackexchange.com/questions/8378/dump-the-output-of-internal-vim-command-into-buffer)
"
" [^6]: [Turn off highlighting a certain pattern in vim](https://stackoverflow.com/questions/19137601/turn-off-highlighting-a-certain-pattern-in-vim)
"
" [^7]: https://github.com/editorconfig/editorconfig-vim#readme
" [^8]: https://svelte.dev/blog/setting-up-your-editor
" [^9]: " Persistent undo: It’s possible to make your edit history persistent across file closure. This lets you make a bunch of edits to a file, :wq it, realise you made a mistake, reopen the file and then undo your edits from your last session with the regular u command. Simply create an undo directory, e.g. ~/.vim/undodir and the following to your .vimrc:
" [^10]: [Tmux and Vim — even better together](https://www.bugsnag.com/blog/tmux-and-vim)
" [^11]: [refresh changed content of file opened in vi(m)](https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim)
" [^12]: [Comments for html and markdown #90](https://github.com/tpope/vim-commentary/issues/90#issuecomment-312519772)
" [^13]: [Unsaved buffer warning when switching files/buffers](https://stackoverflow.com/questions/2414626/unsaved-buffer-warning-when-switching-files-buffers)
" [^14]: [Vimux docs :help vimux](https://raw.githubusercontent.com/preservim/vimux/master/doc/vimux.txt)
" [^15]: [Automatically highlight all occurrences of the selected text in visual mode](https://vi.stackexchange.com/questions/20077/automatically-highlight-all-occurrences-of-the-selected-text-in-visual-mode)
" [^16]: [Better cursor movement in Vim](http://bit-101.com/techtips/2018/02/23/Better-cursor-movement-in-vim/)
" [^17]: [Editing text with Vim, Goyo and Limelight](http://www.bit-101.com/techtips/2018/02/24/Editing-text-with-Vim-Goyo-and-Limelight/)





