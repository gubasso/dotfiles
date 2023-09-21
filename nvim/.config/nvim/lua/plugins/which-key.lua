local truezen = require'true-zen'
local tlb = require'telescope.builtin'

local wk_opts = { prefix = '<leader>' }
local wk_opts_v = { prefix = '<leader>', mode = "v" }
local wk_opts_no_leader_v = { mode = "v" }
-- local wk_opts_no_leader_i = { mode = "i" }

-- local dap_keys = {
--   b = {
--     name = 'dap deBbug',
--     b = { function ()
--       require'dap'.toggle_breakpoint()
--     end, 'Toggle Breakpoint' },
--     c = { function ()
--       require'dap'.continue()
--     end, 'Laungh / resume' },
--     o = { function ()
--       require'dap'.step_over()
--     end, 'Step Over' },
--     i = { function ()
--       require'dap'.step_into()
--     end, 'Step Into' },
--   }
-- }

local vimux_keys = {
  v = {
    name = 'vimux',
    o = { '<cmd>VimuxOpenRunner<cr>', 'Vimux Open Runner' },
    c = { '<cmd>VimuxPromptCommand<cr>', 'Vimux Prompt Command' },
    l = { '<cmd>VimuxRunLastCommand<cr>', 'Vimux Run Last Command' },
    i = { '<cmd>VimuxInspectRunner<cr>', 'Vimux Inspect Runner' },
    q = { '<cmd>VimuxCloseRunner<cr>', 'Vimux Close Runner' },
  }
}

local rust_keys = {
  r = {
    name = "rust",
    t = { '<cmd>wa<CR><cmd>call VimuxRunCommand("clrm; cargo test -p " . expand("%:.:h:h") . " -- --nocapture --test-threads 1")<cr>', 'Run Test this file' },
    c = { '<cmd>wa<CR><cmd>call VimuxRunCommand("clrm; cargo clippy --package " . expand("%:.:h:h"))<cr>', 'Run Cargo Clippy' },
    f = { '<cmd>wa<CR><cmd>call VimuxRunCommand("clrm; cargo fmt --check")<cr>', 'Run Rust Fmt Format' },
    ['fd'] = { '<cmd>wa<CR><cmd>call VimuxRunCommand("clrm; cargo fmt")<cr>', 'Run Rust Fmt Format' },
  }
}


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
  g = {
    x = { [[:silent execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>]] , "open in browser" }
  }
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
  -- h = { ":nohlsearch<CR>", "" },
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
    d = { function() require'telescope'.extensions.dap.commands{} end, "Dap commands" },
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
    -- to toggle nvim-cmp: https://github.com/hrsh7th/nvim-cmp/issues/429#issuecomment-980843997
    t = { '<Plug>(toggle-lsp-diag)', "Lsp Toogle" },
    e = { function ()
      require('cmp').setup.buffer { enabled = true }
    end, "nvim cmp show/enable in this buffer"},
    d = { function ()
      require('cmp').setup.buffer { enabled = false }
    end, "nvim cmp hide/disable in this buffer"},
  }
}

return {
  {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wk = require("which-key")
      wk.register(gen_map_leader, wk_opts)
      wk.register(vimux_keys, wk_opts)
      wk.register(rust_keys, wk_opts)
      wk.register(copy_paste_cut_reg, wk_opts_v)
      wk.register(copy_paste_cut_reg, wk_opts)
      -- wk.register(dap_keys, wk_opts)
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

