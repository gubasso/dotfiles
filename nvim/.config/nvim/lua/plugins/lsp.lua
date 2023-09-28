return {
  {
    "williamboman/mason.nvim",
  },

  {
    "neovim/nvim-lspconfig",
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require("mason").setup()
      require("mason-lspconfig").setup()
      local ensure_installed = {
        'bashls',
        'pkgbuild_language_server',
        'lua_ls',
        'vimls',
        "rust_analyzer",
        'svelte',
        'html',
        'tsserver',
        'cssls',
        'pylsp',
        'marksman',
      }
      local handlers = {

        function (server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,

        ["lua_ls"] = function ()
          lspconfig.lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                }
              }
            }
          }
        end,

      }
      require("mason-lspconfig").setup {
        handlers = handlers,
        automatic_installation = true,
        ensure_installed = ensure_installed,
      }
    end,
  },

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MasonToolsStartingInstall',
        callback = function()
          vim.schedule(function()
            print 'mason-tool-installer is starting'
          end)
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MasonToolsUpdateCompleted',
        callback = function(e)
          vim.schedule(function()
            -- print the table that lists the programs that were installed
            print(vim.inspect(e.data))
          end)
        end,
      })
      local opts = {
        ensure_installed = {
          'bash-language-server',
          'lua-language-server',
          'vim-language-server',
          'stylua',
          'shellcheck',
          'editorconfig-checker',
          'json-to-struct',
          'misspell',
          'codelldb',
          'rust-analyzer',
          'rustfmt',
          'editorconfig-checker',
        },
        auto_update = true,
      }
      require('mason-tool-installer').setup(opts)
    end,
  },

  {
    'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
    keys = {
      { '<leader>ul', '<Plug>(toggle-lsp-diag)', desc = 'Toggle All Lsp Diag' },
      { '<leader>uL', '<Plug>(toggle-lsp-diag-default)', desc = 'Set All Lsp to default' },
      { '<leader>ut', '<Plug>(toggle-lsp-diag-vtext)', desc = 'Lsp Vtext Toggle' },
    },
    config = function ()
      require('toggle_lsp_diagnostics').init()
    end,
  },

  {
    "mhanberg/output-panel.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").register({
        prefix = '<leader>',
        l = { ':OutputPanel', "Lsp OutputPanel" },
      })
      require("output_panel").setup()
    end
  },

}
