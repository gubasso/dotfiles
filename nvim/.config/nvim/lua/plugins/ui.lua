return {
  -- colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd("colorscheme catppuccin-frappe")
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
    },
    -- init = function()
    --   vim.cmd("colorscheme tokyonight")
    -- end
  },
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    -- init = function()
    --   vim.cmd("colorscheme nord")
    -- end
  },
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
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
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
          -- theme = 'nord',
          theme = 'catppuccin',
          section_separators = '',
          component_separators = '',
        }
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function ()
      require("ibl").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      }
    end
  },
}
