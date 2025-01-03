return {
  -- colorscheme
  {
      "chrsm/paramount-ng.nvim",
      dependencies = {
        "rktjmp/lush.nvim"
      },
      lazy = false,
      priority = 1000,
      init = function()
          vim.cmd.colorscheme("paramount-ng")
      end,
  },
  -- {
  --   "neanias/everforest-nvim",
  --   version = false,
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   -- Optional; default configuration will be used if setup isn't called.
  --   config = function()
  --     require("everforest").setup({
  --       -- Your config here
  --       background = "soft",
  --       vim.cmd([[colorscheme everforest]])
  --     })
  --   end,
  -- },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },
  -- noicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = false,
      },
      popupmenu = {
        backend = "cmp",
      },
      messages = {
        enabled = false,
      },
      lsp = {
        progress = {
          enabled = false,
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          auto_open = {
            enabled = false,
            trigger = false,
          }
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
    config = function(_, opts)
      local no = require"noice"
      require("which-key").register({
        prefix = '<leader>',
        ['sn'] = {
          name = "+noice" ,
          l = { function() no.cmd("last") end, "Noice Last Message" },
          h = { function() no.cmd("history") end, "Noice History" },
          a = { function() no.cmd("all") end, "Noice All" },
          d = { function() no.cmd("dismiss") end, "Dismiss All" },
        },
      })

      require("which-key").register({
        mode = 'c',
        ['<S-Enter>'] = {
          function() no.redirect(vim.fn.getcmdline()) end,
          "Redirect Cmdline",
        },
      })
      no.setup(opts)
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    config = function()
      require('lualine').setup {
        options = {
          -- theme = 'catppuccin',
          section_separators = '',
          component_separators = '',
        }
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function ()
      local config = require("ibl.config").default_config
      config.indent.tab_char = config.indent.char
      config.scope.enabled = false
      config.indent.char = "|"
      require("ibl").setup(config)
    end
  },
}
