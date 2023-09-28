return {
  {
    "folke/which-key.nvim",
    lazy = false,
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      vim.cmd([[
      " [Automatically highlight all occurrences of the selected text in visual mode](https://vi.stackexchange.com/questions/20077/automatically-highlight-all-occurrences-of-the-selected-text-in-visual-mode)
      " highlight the visual selection after pressing enter.
      xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
      " Put <enter> to work too! Otherwise <enter> moves to the next line, which we can
      " already do by pressing the <j> key, which is a waste of keys!
      " Be useful <enter> key!:
      nnoremap <silent> <leader><cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
]])
    end,
    opts = {
      plugins = {
        spelling = true,
        suggestions = 20,
      },
    },
    --defaults = {
    --         ["<leader><tab>"] = { name = "+tabs" },
    --         ["<leader>b"] = { name = "+buffer" },
    --         ["<leader>c"] = { name = "+code" },
    --         ["<leader>f"] = { name = "+file/find" },
    --         ["<leader>g"] = { name = "+git" },
    --         ["<leader>gh"] = { name = "+hunks" },
    --         ["<leader>q"] = { name = "+quit/session" },
    --         ["<leader>u"] = { name = "+ui" },
    --         ["<leader>w"] = { name = "+windows" },
    --},
    config = function()
      require("which-key").register({
        ["g"] = { name = "+goto" },
        ["<LocalLeader>r"] = { name = "+rust" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>e"] = { name = "+explorer" },
        ["<leader>z"] = { name = "+zen/focus mode" },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>u"] = { name = "+deactivate" },
        ["gx"] = {[[:silent execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<cr>]], "open in browser" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>w"] = {':wa<CR>', 'Save all'},
        ["<leader>q"] = {'<cmd>wa<CR><cmd>q<CR>', 'Save all and Quit'},
        ["<leader><tab>"] = { "<cmd>b#<CR>", "" },
        ["<c-c>"] = { ':set hlsearch!<cr>' , "toggles hlsearch" },
      })
      require("which-key").register({
        mode = "v",
        ["<"] = { "<gv", "" },
        [">"] = { ">gv", "" },
      })
      require("which-key").register({
        mode = { "n", "v" },
        prefix = '<leader>',
        y = { '"+y' , "clipboard y"},
        Y = { '"+yg_' , "clipboard Y"},
        ['yy'] = { '"+yy' , "clipboard yy"},
        d = { '"+d' , "clipboard d"},
        D = { '"+D' , "clipboard D"},
        ['dd'] = { '"+dd' , "clipboard dd"},
        p = { '"+p' , "clipboard p"},
        P = { '"+P' , "clipboard P"},
        --         ["<cr>"] = { [[:let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>]] , "highlight word under cursor" },
      })
    end,
  },
}
