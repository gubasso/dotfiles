return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      'hrsh7th/nvim-cmp',
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers {
        function (server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end,
        ["lua_ls"] = function ()
          require'lspconfig'.lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = { globals = {'vim'}, },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = { enable = false, },
              },
            },
          }
        end,
      }
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    lazy = false,
    depedencies = { "williamboman/mason.nvim" },
    config = function()
      require('mason-tool-installer').setup {
        auto_update = true,
        run_on_start = true,
        start_delay = 0,
        debounce_hours = 5,
      }
    end,
  },
  { "jose-elias-alvarez/null-ls.nvim", lazy = false },
  {
    "jay-babu/mason-null-ls.nvim",
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        automatic_installation = false,
        automatic_setup = true,
      })
      require("null-ls").setup()
      require 'mason-null-ls'.setup_handlers()
    end,
  },
  { "mfussenegger/nvim-dap", lazy = false },
  {
    "jay-babu/mason-nvim-dap.nvim",
    lazy = false,
    config = function()
      require("mason-nvim-dap").setup({
        automatic_setup = true,
      })
      require 'mason-nvim-dap'.setup_handlers {}
    end,
  },
  {
    'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
    config = function ()
      require('toggle_lsp_diagnostics').init()
    end,
  },
}
