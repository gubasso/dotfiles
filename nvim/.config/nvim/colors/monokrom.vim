
" Vim color scheme
"
" Name:       monokrom.vim
" Maintainer: Alexander Heldt <me@alexanderheldt.se>
" License:    MIT

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "monokrom"

let s:palette = g:monokrom#palette

let s:black         = g:monokrom#palette.grey11
let s:bg            = g:monokrom#palette.grey15
let s:bg_light      = g:monokrom#palette.grey19
let s:bg_lighter    = g:monokrom#palette.grey23
let s:nothing       = g:monokrom#palette.grey27
let s:fg_darker     = g:monokrom#palette.grey39
let s:fg_dark       = g:monokrom#palette.grey46
let s:fg            = g:monokrom#palette.grey78

let s:white         = g:monokrom#palette.white
let s:blue          = g:monokrom#palette.blue
let s:green         = g:monokrom#palette.green
let s:red           = g:monokrom#palette.red
let s:orange        = g:monokrom#palette.orange

let s:splash        = g:monokrom#palette.yellow

let s:bold      = 'bold'
let s:underline = 'underline'
let s:none      = 'NONE'

" Used to set fg/bg to none
let s:none_list = [s:none, s:none]

function! s:hi(...)
    let group = a:1
    let fg    = get(a:, 2, s:fg)
    let bg    = get(a:, 3, s:none_list)
    let attr  = get(a:, 4, s:none)

    let cmd = ['hi', group]

    call add(cmd, 'ctermfg='.fg[0])
    call add(cmd, 'guifg='.fg[1])

    call add(cmd, 'ctermbg='.bg[0])
    call add(cmd, 'guibg='.bg[1])

    call add(cmd, 'cterm='.attr)
    call add(cmd, 'gui='.attr)

    exec join(cmd, ' ')
endfunction

" UI {{{
set background=dark

" Column length lines
call s:hi('ColorColumn', s:none_list, s:black)

call s:hi('Conceal', s:fg_darker)

" Cursor
call s:hi('Cursor', s:fg, s:splash)
call s:hi('CursorColumn', s:none_list, s:bg_light)
call s:hi('CursorLine', s:none_list, s:bg_light)

call s:hi('Directory', s:splash, s:none_list)

" Tildes in the end of the buffer after the file end
call s:hi('EndOfBuffer', s:nothing)

" Messages : {{{
call s:hi('Error', s:red)
call s:hi('ErrorMsg', s:red)
call s:hi('Warning', s:orange)
call s:hi('WarningMsg', s:orange)
call s:hi('ModeMsg', s:fg_dark)
call s:hi('MoreMsg', s:fg_dark)

" neoclide/coc.nvim
call s:hi('CocInfoSign', s:blue)
call s:hi('CocInfoHighlight', s:blue)
call s:hi('CocInfoFloat', s:blue)

call s:hi('CocWarningSign', s:orange)
call s:hi('CocWarningHighlight', s:orange)
call s:hi('CocWarningFloat', s:orange)

call s:hi('CocErrorSign', s:red)
call s:hi('CocErrorHighlight', s:red)
call s:hi('CocErrorFloat', s:red)
" }}}

" The vertical split between buffers
call s:hi('VertSplit', s:bg_light, s:bg_light)

" Folding
call s:hi('Folded', s:fg_dark, s:black)
call s:hi('FoldColumn', s:fg_darker)
call s:hi('SignColumn', s:fg_dark)

" Line numbers
call s:hi('LineNr', s:fg_darker)
call s:hi('CursorLineNr', s:splash, s:bg_light)

" Matching bracket for the one under the cursor
call s:hi('MatchParen', s:splash, s:none_list, s:bold)

call s:hi('Normal', s:fg, s:bg, s:none)
call s:hi('NonText', s:nothing)
hi! link Ignore NonText

" Popup menu
call s:hi('NormalFloat', s:fg, s:black)
call s:hi('Pmenu', s:fg, s:black)
call s:hi('PmenuSbar', s:none_list)
call s:hi('PmenuSel', s:splash)
call s:hi('PmenuThumb', s:none_list, s:splash)

call s:hi('Question', s:fg_dark)

call s:hi('QuickFixLine', s:none_list, s:black)

" Unprintable characters
call s:hi('SpecialKey', s:fg_dark)

" Spelling
call s:hi('SpellBad', s:red, s:none_list, s:underline)
call s:hi('SpellCap', s:red, s:none_list, s:underline)
call s:hi('SpellLocal', s:red, s:none_list, s:underline)
call s:hi('SpellRare', s:red, s:none_list, s:underline)

" Status line
call s:hi('StatusLine', s:splash, s:bg_lighter)
call s:hi('StatusLineNC', s:fg_dark, s:bg_light)

" Tabs
call s:hi('TabLine', s:fg_dark, s:bg_light)
call s:hi('TabLineFill', s:fg_dark, s:bg_light)
call s:hi('TabLineSel', s:splash, s:bg_lighter)

call s:hi('Title', s:fg, s:none_list, s:bold)

" Visual selection
call s:hi('Visual', s:none_list, s:bg_lighter)
call s:hi('VisualNOS', s:none_list, s:nothing)

call s:hi('helpHyperTextJump', s:splash)
" }}}

" Syntax: {{{
call s:hi('Comment', s:fg_darker)
call s:hi('Constant', s:splash)
call s:hi('Identifier', s:fg_dark)
call s:hi('Function')
call s:hi('Macro')
call s:hi('Statement', s:fg_dark)
call s:hi('PreProc', s:fg_darker)
call s:hi('Type', s:fg_darker)
call s:hi('Special', s:fg_dark)
call s:hi('Todo', s:white)
call s:hi('Underlined', s:fg, s:none_list, s:underline)
" }}}

" Git: {{{
call s:hi('DiffAdd', s:green)
call s:hi('DiffChange', s:blue)
call s:hi('DiffDelete', s:red)

call s:hi('diffAdded', s:green)
call s:hi('diffRemoved', s:red)

" airblade/vim-gitgutter
call s:hi('GitGutterAdd', s:green)
call s:hi('GitGutterChange', s:blue)
call s:hi('GitGutterDelete', s:red)
" }}}

" Search : {{{
call s:hi('IncSearch', s:bg, s:splash)
call s:hi('Search', s:bg, s:splash)

" junegunn/fzf.vim
call s:hi('Monokrom_FZF_Splash', s:splash)
call s:hi('Monokrom_FZF_CurrentLine', s:white, s:bg_light)
call s:hi('Monokrom_FZF_Info', s:fg_darker)
hi! link Monokrom_FZF_Normal Normal

if !exists('g:fzf_colors')
    " https://github.com/junegunn/fzf/wiki/Color-schemes
    let g:fzf_colors = {
        \ 'fg':         ['fg', 'Monokrom_FZF_Normal'],
        \ 'bg':         ['bg', 'Monokrom_FZF_Normal'],
        \ 'fg+':        ['fg', 'Monokrom_FZF_CurrentLine'],
        \ 'bg+':        ['bg', 'Monokrom_FZF_CurrentLine'],
        \ 'hl':         ['fg', 'Monokrom_FZF_Splash'],
        \ 'hl+':        ['fg', 'Monokrom_FZF_Splash'],
        \ 'info':       ['fg', 'Monokrom_FZF_Info'],
        \ 'prompt':     ['fg', 'Monokrom_FZF_Splash'],
        \ 'pointer':    ['fg', 'Monokrom_FZF_Splash'],
        \ 'marker':     ['fg', 'Monokrom_FZF_Splash'],
        \ 'spinner':    ['fg', 'Monokrom_FZF_Splash'],
        \ 'header':     ['fg', 'Monokrom_FZF_Splash'],
        \}
endif
" }}}
