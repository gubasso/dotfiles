local U = require("core.utils")

return {
  { "<CR>", U.highlight_selection, desc = "Highlighting visual selection", mode = "v" },
  { "<leader><CR>", U.highlight_cword, desc = "Highlighting word under cursor" },
  { "gx", U.open_in_browser, desc = "Open under-cursor in browser" },
  { "<leader>w", ":wa<CR>",           desc = "Save all" },
  { "<leader>q", "<cmd>wa<CR><cmd>q<CR>", desc = "Save all and Quit" },
  { "<leader><tab>", "<cmd>b#<CR>",   desc = "" }, -- (empty desc is fine)
  -- Resize window using <ctrl> arrow keys
  { "<c-c>", ":set hlsearch!<cr>",    desc = "Toggle hlsearch" },
  { "<C-Up>", "<cmd>resize +2<cr>",   desc = "Increase window height" },
  { "<C-Down>", "<cmd>resize -2<cr>", desc = "Decrease window height" },
  { "<C-Left>", "<cmd>vertical resize -2<cr>",  desc = "Decrease window width" },
  { "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Increase window width" },
  -- Move Lines
  { "<A-j>", "<cmd>m .+1<cr>==", desc = "Move line down" },
  { "<A-k>", "<cmd>m .-2<cr>==", desc = "Move line up" },

  -- Visual mode mappings
  {
    mode = "v",
    { "<A-j>", ":m '>+1<CR>gv=gv", desc = "Move selected lines down" },
    { "<A-k>", ":m '<-2<CR>gv=gv", desc = "Move selected lines up"   },
    { "<",     "<gv",              desc = ""          },
    { ">",     ">gv",              desc = ""          },
  },

  -- Insert mode mappings
  {
    mode = "i",
    { "<A-j>", "<Esc>:m .+1<CR>==gi", desc = "Move line down in Insert mode" },
    { "<A-k>", "<Esc>:m .-2<CR>==gi", desc = "Move line up in Insert mode" },
  },

  -- Normal mode clipboard mappings
  {
    { "<leader>yy", '"+yy',  desc = "clipboard yy" },
    { "<leader>yw", '"+yiw',  desc = "clipboard yiw" },
    { "<leader>yl", '"+yiW',  desc = "clipboard yiW" },
    { "<leader>Y",  '"+yg_', desc = "clipboard Y"  },
    { "<leader>D",  '"+D',   desc = "clipboard D"  },
    { "<leader>dd", '"+dd',  desc = "clipboard dd" },
    { "<leader>p",  '"+p',   desc = "clipboard p"  },
    { "<leader>P",  '"+P',   desc = "clipboard P"  },
  },

  -- Normal + Visual mode clipboard mappings
  {
    mode = { "n", "v" },
    { "<leader>y",  '"+y',   desc = "clipboard y"  },
    { "<leader>d",  '"+d',   desc = "clipboard d"  },
  },

  -- Command-line mode
  -- Allow saving of files as sudo when I forgot to start vim using sudo
  {
    mode = { "c" },
    { "w!!",  "w !sudo tee > /dev/null %",   desc = "Save of files as sudo"  },
  },

}
