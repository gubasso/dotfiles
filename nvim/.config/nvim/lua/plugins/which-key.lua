local truezen = require('true-zen')
local tlb = require('telescope.builtin')

local wk_opts = { prefix = '<leader>' }
local wk_opts_v = { prefix = '<leader>', mode = "v" }
local wk_opts_no_leader_v = { mode = "v" }
-- local wk_opts_no_leader_i = { mode = "i" }

local trouble = {
  t = {
    name = "Trouble",
    x = { "<cmd>TroubleToggle<cr>", "TroubleToggle" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "TroubleToggle workspace_diagnostics" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "TroubleToggle document_diagnostics" },
    l = { "<cmd>TroubleToggle loclist<cr>", "TroubleToggle loclist" },
    q = { "<cmd>TroubleToggle quickfix<cr>", "TroubleToggle quickfix" },
    r = { "<cmd>TroubleToggle lsp_references<cr>", "TroubleToggle lsp_references" },
  }
}

local nvim_tree = {
  e = {
    name = "NvimTree",
    e = { ":NvimTreeToggle<cr>" , "NvimTreeToggle" },
    f = { ":NvimTreeFindFile<cr>", "NvimTreeFindFile" }
  }
}

local map_no_leader = {
  ['<C-p>'] = { function() tlb.find_files() end, "tl files" },
  ['<C-f>'] = { function() tlb.live_grep() end, "tl fuzzy search" },
}

local map_no_leader_v = {
  ["<"] = { "<gv", "" },
  [">"] = { ">gv", "" },
}

local gen_map_leader = {
  q = {'<cmd>NvimTreeClose<cr><cmd>wa<CR><cmd>q<CR>', 'Save all and Quit'},
  w = {':wa<CR>', 'Save all'},
  x = {':bd<CR>', 'Buffer Del'},
  ["<tab>"] = { "<cmd>b#<CR>", "" },
  h = { ":nohlsearch<CR>", "" },
}

local copy_paste_cut_reg = {
  y = { '"+y' , ""},
  Y = { '"+Y' , ""},
  ['yy'] = { '"+yy' , ""},
  d = { '"+d' , ""},
  D = { '"+D' , ""},
  ['dd'] = { '"+dd' , ""},
  p = { '"+p' , ""},
  P = { '"+P' , ""},
}


local map_telescope = {
  f = {
    name = "telescope",
    b = { function() tlb.buffers() end, "tl buffers" },
    h = { function() tlb.help_tags() end, "tl help_tags" },
    m = { function() tlb.keymaps() end, "tl keymaps" },
    t = { ":Telescope<cr>", "Telescope" },
  }
}

local map_markdown_preview = {
  m = {
    name = "markdown preview",
    p = { "<Plug>MarkdownPreviewToggle", "MarkdownPreviewToggle" },
    m = { "<Plug>MarkdownPreview", "MarkdownPreview" },
    s = { "<Plug>MarkdownPreviewStop", "MarkdownPreviewStop" },
  }
}

local map_focus_n = {
  z = {
    name = "zoom/focus",
    n = { function ()
      local first = 0
      local last = vim.api.nvim_buf_line_count(0)
      truezen.narrow(first, last)
    end, "TZNarrow N"  },
    f = { truezen.focus, "TZFocus" },
    m = { truezen.minimalist,"TZMinimalist" },
    a = { truezen.ataraxis,"TZAtaraxis" },
    t = {':Twilight<cr>', 'Twilight'},
  }
}
local map_focus_v = {
  z = {
    name = "zoom/focus",
    n = { function ()
      local first = vim.fn.line('v')
      local last = vim.fn.line('.')
      truezen.narrow(first, last)
    end, "TZNarrow V"  },
  }
}

local map_lsp = {
  l = {
    name = "lsp",
    t = { '<Plug>(toggle-lsp-diag)', "Lsp Toogle" }
  }
}

return {
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wk = require("which-key")
      wk.register(gen_map_leader, wk_opts)
      wk.register(copy_paste_cut_reg, wk_opts_v)
      wk.register(copy_paste_cut_reg, wk_opts)
      wk.register(nvim_tree, wk_opts)
      wk.register(trouble, wk_opts)
      wk.register(map_no_leader_v, wk_opts_no_leader_v)
      wk.register(map_markdown_preview, wk_opts)
      wk.register(map_telescope, wk_opts)
      wk.register(map_no_leader)
      wk.register(map_focus_n, wk_opts)
      wk.register(map_focus_v, wk_opts_v)
      wk.register(map_lsp, wk_opts)
      wk.setup {
        plugins = {
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = false,
            nav = false,
            z = true,
            g = true,
          },
        },
      }
    end,
  },
}

