return {
  { 'jiangmiao/auto-pairs' },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      local oil = require("oil")
      require("which-key").register({
        ["-"] = { oil.open, "Open parent directory" },
      })
      oil.setup()
    end
  },
  {
    'preservim/vimux',
    lazy = false,
    config = function ()
      vim.cmd([[
          let g:VimuxHeight = "45"
          let g:VimuxOrientation = "h"
          ]])
      require("which-key").register({
        prefix = "<leader>v",
        name = 'vimux',
        o = { '<cmd>VimuxOpenRunner<cr>', 'Vimux Open Runner' },
        c = { '<cmd>VimuxPromptCommand<cr>', 'Vimux Prompt Command' },
        l = { '<cmd>VimuxRunLastCommand<cr>', 'Vimux Run Last Command' },
        i = { '<cmd>VimuxInspectRunner<cr>', 'Vimux Inspect Runner' },
        q = { '<cmd>VimuxCloseRunner<cr>', 'Vimux Close Runner' },
      })
    end
  },
  { 'wellle/targets.vim' },
  {
    'mzlogin/vim-markdown-toc',
    config = function ()
      vim.g.vmt_fence_text = 'toc'
      vim.g.vmt_cycle_list_item_markers = 1
      vim.g.vmt_fence_hidden_markdown_style = ''
    end
  },
  {
    "christoomey/vim-tmux-navigator",
    config = function ()
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end
  },
  { "norcalli/nvim-colorizer.lua", config = true, },
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },
  {
    "folke/twilight.nvim",
    config = function()
      require("which-key").register({
        prefix = '<leader>z',
        a = { ":Twilight<CR>", "Twilight" },
      })
    end,
  },
  {
    "Pocco81/true-zen.nvim",
    config = function()
      local truezen = require'true-zen'
      require("which-key").register({
        prefix = '<leader>z',
        n = { function ()
          local first = 0
          local last = vim.api.nvim_buf_line_count(0)
          truezen.narrow(first, last)
        end, "TZNarrow N"  },
        f = { truezen.focus, "TZFocus" },
        m = { truezen.minimalist,"TZMinimalist" },
        a = { truezen.ataraxis,"TZAtaraxis" },
        t = {':Twilight<cr>', 'Twilight'},
      })
      require("which-key").register({
        prefix = '<leader>z',
        mode = 'v',
        n = { function ()
          local first = vim.fn.line('v')
          local last = vim.fn.line('.')
          truezen.narrow(first, last)
        end, "TZNarrow V"  },
      })
      require("true-zen").setup {}
    end,
  },
  -- explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("which-key").register({
        prefix = '<leader>',
        e = {
          e = {
            function()
              require("neo-tree.command").execute({
                toggle = true,
                source = "filesystem",
                position = "left",
              })
            end, "Files (Neotree)"
          },
          ["."] = {
            function()
              require("neo-tree.command").execute({
                toggle = true,
                source = "filesystem",
                position = "current",
              })
            end, "Files (netrw style)"
          },
          f = {
            function()
              require("neo-tree.command").execute({
                toggle = true,
                source = "filesystem",
                position = "left",
                reveal = true,
              })
            end, "Curr File (Neotree)"
          },
          b = {
            function()
              require("neo-tree.command").execute({
                toggle = true,
                source = "buffers",
                position = "left",
              })
            end, "Buffers"
          },
          g = {
            function()
              require("neo-tree.command").execute({
                toggle = true,
                source = "git_status",
                position = "left",
              })
            end, "Git Status"
          },
        }
      })
      local opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        -- Enable normal mode for input dialogs.
        enable_normal_mode_for_inputs = true,
        filesystem = {
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = true,
          },
        },
        window = {
          position = 'current',
          mappings = {
            ['e'] = function()
              vim.api.nvim_exec('Neotree focus filesystem left', true)
            end,
            ['b'] = function()
              vim.api.nvim_exec('Neotree focus buffers left', true)
            end,
            ['g'] = function()
              vim.api.nvim_exec('Neotree focus git_status left', true)
            end,
            ["o"] = "system_open",
          },
        },
        deactivate = function()
          vim.cmd([[Neotree close]])
        end,
        commands = {
          system_open = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            path = vim.fn.shellescape(path, 1)
            -- macOs: open file in default application in the background.
            vim.api.nvim_command("silent !open -g " .. path)
            -- Linux: open file in default application
            vim.api.nvim_command("silent !xdg-open " .. path)
          end,
        },
      }
      require"neo-tree".setup(opts)
    end,
  },

  {
    "echasnovski/mini.files",
    opts = {
      windows = {
        preview = true,
      },
    },
    keys = {
      {
        "<c-e>",
        function()
          require("mini.files").open(vim.loop.cwd(), true)
        end,
        desc = "Curr File (mini.files)",
      },
      {
        "<c-f>",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Files (mini.files)",
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)
      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh({ content = { filter = new_filter } })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak left-hand side of mapping to your liking
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
        end,
      })
    end,
  },

  -- fuzzy finder
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'folke/todo-comments.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      local tlb = require'telescope.builtin'
      require("which-key").register({
        ['<c-p>'] = { function() tlb.find_files() end, "files" },
        gd = { function() tlb.lsp_definitions({ reuse_win = true }) end, "Goto Definition" },
        gD = { vim.lsp.buf.declaration , "Goto Declaration" },
        gr = { function() tlb.lsp_references() end, "References" },
        gi = { function() tlb.lsp_implementations({ reuse_win = true }) end, "Goto Implementation" },
        gy = { function() tlb.lsp_type_definitions({ reuse_win = true }) end, "Goto T[y]pe Definition" },
        K = { vim.lsp.buf.hover, "Hover"},
        gK = { vim.lsp.buf.signature_help, "Signature Help" },
        ["<c-k>"] = { vim.lsp.buf.signature_help, mode = "i", "Signature Help" },
        ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
        ["[d"] = { vim.diagnostic.goto_prev,  "Prev Diagnostic" },
      })
      require("which-key").register({
        prefix = '<leader>',
        ['/'] = { function() tlb.live_grep() end, "grep" },
        [':'] = { function() tlb.command_history() end, "command history" },
        f = {
          name = 'search',
          ['<cr>'] = { function() tlb.grep_string() end, "grep under cursor" },
          a = { ":Telescope<cr>", "All Telescope" },
          b = { function() tlb.buffers() end, "buffers" },
          h = { function() tlb.help_tags() end, "help_tags" },
          m = { function() tlb.keymaps() end, "keymaps" },
          c = { function() tlb.commands() end, "commands available" },
          t = { "<cmd>TodoTelescope<cr>", desc = "Todo" },
          T = { "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
        },
      })

      local trouble = require("trouble.providers.telescope")
      local telescope = require("telescope")
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<c-t>"] = trouble.open_with_trouble,
              ["<c-h>"] = "which_key",
            },
            n = { ["<c-t>"] = trouble.open_with_trouble },
          },
        },
      }
      require('telescope').load_extension('fzf')
    end,
  },
  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    config = function ()
      require("which-key").register({
        prefix = '<leader>',
        ['bd'] = {
          function()
            require("mini.bufremove").delete(0, false)
          end,
          "Buffer Delete"
        },
      })
    end
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/todo-comments.nvim",
    },
    opts = {
      use_diagnostic_signs = true
    },
    config = function ()
      local tr = require"trouble"
      require("which-key").register({
        ["[q"] = {
          function()
            if require("trouble").is_open() then
              require("trouble").previous({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end,
          "Previous trouble/quickfix item"
        },
        ["]q"] = {
          function()
            if require("trouble").is_open() then
              require("trouble").next({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end,
          "Next trouble/quickfix item"
        },
      })
      require("which-key").register({
        prefix = '<leader>x',
        d = { function() tr.open("document_diagnostics") end, "document"},
        w = { function() tr.open("workspace_diagnostics") end, "workspace"},
        q = { function() tr.open("quickfix") end, "quickfix"},
        l = { function() tr.open("loclist") end, "loclist"},
        r = { function() tr.open("lsp_references") end, "lsp references"},
        t = { "<cmd>TodoTrouble<cr>", "Todo" },
        T = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme" },
      })

    end,
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
      {
        "<s-h>",
        function()
          require("harpoon.mark").add_file()
          require("notify")("harpoon added")
        end,
        desc = "add file",
      },
      {
        "<leader>1",
        function()
          require("harpoon.ui").nav_file(1)
        end,
        desc = "File 1"
      },
      {
        "<leader>2",
        function()
          require("harpoon.ui").nav_file(2)
        end,
        desc = "File 2"
      },
      {
        "<leader>3",
        function()
          require("harpoon.ui").nav_file(3)
        end,
        desc = "File 3"
      },
      {
        "<leader>4",
        function()
          require("harpoon.ui").nav_file(4)
        end,
        desc = "File 4"
      },
      {
        "<leader>5",
        function()
          require("harpoon.ui").nav_file(5)
        end,
        desc = "File 5"
      },
      {
        "<leader>6",
        function()
          require("harpoon.ui").nav_file(6)
        end,
        desc = "File 6"
      },
      {
        "<leader>7",
        function()
          require("harpoon.ui").nav_file(7)
        end,
        desc = "File 7"
      },
      {
        "<leader>8",
        function()
          require("harpoon.ui").nav_file(8)
        end,
        desc = "File 8"
      },
      {
        "<leader>9",
        function()
          require("harpoon.ui").nav_file(9)
        end,
        desc = "File 9"
      },
      {
        "<leader>ha",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "add file"
      },
      {
        "<leader>hh",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "menu"
      },
      {
        "<leader>hp",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "prev mark"
      },
      {
        "<leader>hn",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "next mark"
      },
    },
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
    },
  },

}