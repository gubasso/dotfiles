return {
  -- linter
  {
    "mfussenegger/nvim-lint",
    init = function ()
      require('lint').linters_by_ft = {
        python = {'flake8'},
      }
    end
  },
  -- align / tabular
  { "junegunn/vim-easy-align" },
  { "godlygeek/tabular" },
  { "gpanders/editorconfig.nvim" },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    init = function()
      local ls = require("luasnip")
      local wk = require("which-key")

      wk.add({
        -- 1) Insert mode mapping (expand snippet)
        {
          mode = "i",
          { "<c-K>", ls.expand, desc = "Expand snippet" },
        },

        -- 2) Insert + Select mode mappings
        {
          mode = { "i", "s" },
          { "<c-L>", function() ls.jump(1) end,  desc = "Jump snippet forward" },
          { "<c-J>", function() ls.jump(-1) end, desc = "Jump snippet backward" },
          {
            "<c-E>",
            function()
              if ls.choice_active() then
                ls.change_choice(1)
              end
            end,
            desc = "Change snippet choice",
          },
        },
      })
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {
        check_ts = true,
        fast_wrap = {},
      }
    end,
  },

  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-cmdline" },
  { "saadparwaiz1/cmp_luasnip" },
  { "hrsh7th/cmp-emoji" },
  { "chrisgrieser/cmp-nerdfont" },
  {
    "jcha0713/cmp-tw2css",
    config = function ()
      require('cmp-tw2css').setup()
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-emoji",
      "chrisgrieser/cmp-nerdfont",
      'windwp/nvim-autopairs',
      "jcha0713/cmp-tw2css",
    },

    keys = {
      {
        '<leader>uC',
        function ()
          require('cmp').setup.buffer { enabled = true }
        end,
        desc = 'Cmp enable (show) in this buffer'
      },
      {
        '<leader>uc',
        function ()
          require('cmp').setup.buffer { enabled = false }
        end,
        desc = 'Cmp disable (hide) in this buffer'
      },
    },

    config = function()
      local cmp = require'cmp'
      local defaults = require("cmp.config.default")()
      local opts = {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'cmp-tw2css' },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = 'nvim_lsp_signature_help' },
          { name = "buffer" },
          { name = "path" },
          { name = "emoji" },
          { name = 'nerdfont' },
        }),
        sorting = defaults.sorting,
        -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#custom-menu-direction
        view = {
          entries = {name = 'custom', selection_order = 'near_cursor' }
        },
      }
      cmp.setup(opts)
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'path' },
            { name = 'cmdline' },
        }
      })
      -- https://github.com/windwp/nvim-autopairs#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo
      cmp.event:on(
        'confirm_done',
        require('nvim-autopairs.completion.cmp').on_confirm_done()
      )
    end,
  },
  -- nvim-cmp end --

  {
    "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = true,
    },

    -- comments
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      dependencies = { "nvim-treesitter/nvim-treesitter", },
      lazy = true,
      opts = {
        enable_autocmd = false,
    },
  },
  {
    'numToStr/Comment.nvim',
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    lazy = false,
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local td = require("todo-comments")

      require("which-key").add({
        { "]t", td.jump_next, desc = "Next todo comment" },
        { "[t", td.jump_prev, desc = "Previous todo comment" },
      })
    end
  },

  {
    "echasnovski/mini.icons"
  },

  -- Better text-objects
  {
    'echasnovski/mini.ai',
    version = '*',
    opts = {},
  },

  {
    "smjonas/inc-rename.nvim",
    config = function()
      local ic = require("inc_rename")
      local wk = require("which-key")

      wk.add({
        {
          "<leader>cR", ":IncRename ", desc = "Rename <new_name>`",
        },
        {
          "<leader>cr",
          function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end,
          desc = "Rename `curr_name`+<increment>",
          expr = true
        },
      })

      ic.setup {
        input_buffer_type = "dressing"
      }
    end,
  },

  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = true,
  },

  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    keys = {
      { "<leader>cS", function() require("spectre").toggle() end, desc = 'Spectre Toggle' },
      { "<leader>cw", function() require("spectre").open_visual({select_word=true}) end, desc = 'Spectre Search current word' },
      { "<leader>cw", function() require("spectre").open_visual({select_word=true}) end, desc = 'Spectre Search current word', mode = 'v' },
      { "<leader>c/", function() require("spectre").open_file_search({select_word=true}) end, desc = 'Spectre Search on current file' },
    }
  },

  {
    "sindrets/diffview.nvim",
    opts = {
      view = {
        merge_tool = {
          layout = "diff4_mixed",
        }
      }
    },
  },
  {
    "tpope/vim-fugitive",
    keys = {
      { "gs", ":Git<CR>", desc = "Git Status" },
      { "<leader>gs", ":Git<CR>", desc = "Git Status" },
      { "<leader>gp", ":Git push<CR>", desc = "Git Push" },
      { "<leader>gl", ":Git pull<CR>", desc = "Git Push" },
    },
  },
  -- in file diff view
  {'akinsho/git-conflict.nvim', version = "*", config = true},
  { "olrtg/nvim-emmet" },
}
