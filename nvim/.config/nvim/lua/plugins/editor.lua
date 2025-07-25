return {
  { 'jiangmiao/auto-pairs' },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      local oil = require("oil")
      require("which-key").add({
        { "-", oil.open, desc = "Open parent directory" },
      })
      oil.setup()
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
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    config = function ()
      -- recommended mappings
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
      -- moving between splits
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
      vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
      -- swapping buffers between windows
      vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
      vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
      vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
      vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
    end
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function ()
      require'colorizer'.setup({
        'css';
        'javascript';
        html = {
          mode = 'foreground';
        }
      })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },
  {
    "folke/twilight.nvim",
    opts = {},
    keys = {
      { "<leader>zt", "<cmd>Twilight<CR>", desc = "Twilight" },
    },
  },
  {
    "Pocco81/true-zen.nvim",
    config = function()
      local tz = require("true-zen")

      require("which-key").add({
        {
          "<leader>zn",
          function()
            local first = 0
            local last = vim.api.nvim_buf_line_count(0)
            tz.narrow(first, last)
          end,
          desc = "TZNarrow N",
        },
        { "<leader>zf", tz.focus,       desc = "TZFocus" },
        { "<leader>zm", tz.minimalist,  desc = "TZMinimalist" },
        { "<leader>za", tz.ataraxis,    desc = "TZAtaraxis" },
        {
          "<leader>zn",
          mode = "v",
          function()
            local first = vim.fn.line("v")
            local last = vim.fn.line(".")
            tz.narrow(first, last)
          end,
          desc = "TZNarrow V",
        },
      })
      tz.setup {}
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
      local wk = require("which-key")
      local ntcmd = require("neo-tree.command")

      wk.add({
        -- Files (Neotree)
        {
          "<leader>ee",
          function()
            ntcmd.execute({
              toggle = true,
              source = "filesystem",
              position = "left",
            })
          end,
          desc = "Files (Neotree)",
        },
        -- Files (netrw style)
        {
          "<leader>e.",
          function()
            ntcmd.execute({
              toggle = true,
              source = "filesystem",
              position = "current",
            })
          end,
          desc = "Files (netrw style)",
        },
        -- Current File (Neotree)
        {
          "<leader>ef",
          function()
            ntcmd.execute({
              toggle = true,
              source = "filesystem",
              position = "left",
              reveal = true,
            })
          end,
          desc = "Curr File (Neotree)",
        },
        -- Buffers
        {
          "<leader>eb",
          function()
            ntcmd.execute({
              toggle = true,
              source = "buffers",
              position = "left",
            })
          end,
          desc = "Buffers",
        },
        -- Git status
        {
          "<leader>eg",
          function()
            ntcmd.execute({
              toggle = true,
              source = "git_status",
              position = "left",
            })
          end,
          desc = "Git Status",
        },
      })
      local opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        -- Enable normal mode for input dialogs.
        -- enable_normal_mode_for_inputs = true,
        event_handlers = {
          {
            event = "neo_tree_popup_input_ready",
            ---@param args { bufnr: integer, winid: integer }
            handler = function(args)
              vim.cmd("stopinsert")
              vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
            end,
          }
        },
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
      local tlb = require("telescope.builtin")

      require("which-key").add({
        -- General Telescope bindings
        { "<c-p>", tlb.find_files, desc = "Find Files" },
        {
          "gd",
          function() tlb.lsp_definitions({ reuse_win = true }) end,
          desc = "Goto Definition",
        },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "gr", tlb.lsp_references, desc = "References" },
        {
          "gI",
          function() tlb.lsp_implementations({ reuse_win = true }) end,
          desc = "Goto Implementation",
        },
        {
          "gy",
          function() tlb.lsp_type_definitions({ reuse_win = true }) end,
          desc = "Goto T[y]pe Definition",
        },

        -- Leader-key Telescope bindings
        { "<leader>/", tlb.live_grep, desc = "Grep" },
        { "<leader>:", tlb.command_history, desc = "Command History" },

        -- Search category
        { "<leader>f<CR>", tlb.grep_string, desc = "Grep under cursor" },
        { "<leader>fa", ":Telescope<CR>", desc = "All Telescope" },
        { "<leader>fb", tlb.buffers, desc = "Buffers" },
        { "<leader>fh", tlb.help_tags, desc = "Help Tags" },
        { "<leader>fm", tlb.keymaps, desc = "Keymaps" },
        { "<leader>fc", tlb.commands, desc = "Available Commands" },
        { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Todo" },
        {
          "<leader>fT",
          "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>",
          desc = "Todo/Fix/Fixme",
        },
      })

      local trouble = require("trouble.sources.telescope")
      local telescope = require("telescope")
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<c-t>"] = trouble.open,
              ["<c-h>"] = "which_key",
            },
            n = { ["<c-t>"] = trouble.open },
          },
        },
      }
      require('telescope').load_extension('fzf')
    end,
  },
  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    config = function()
      require("which-key").add({
        {
          "<leader>bd",
          function() require("mini.bufremove").delete(0, false) end,
          desc = "Buffer Delete",
        },
      })
    end,
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/todo-comments.nvim",
    },
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xw",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xcs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xcl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
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
  -- {
  --   -- "jackMort/ChatGPT.nvim",
  --   "dreamsofcode-io/ChatGPT.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim"
  --   },
  --   event = "VeryLazy",
  --   keymaps = {
  --     close = { '<C-c>', 'q' }
  --   },
  --   config = function()
  --     -- local secrets = vim.fn.expand("$SECRETS")
  --     require("chatgpt").setup({
  --       async_api_key_cmd = "gopass show -o api_tokens/openai/chatgpt.nvim"
  --     })
  --   end,
  -- }
}
