local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

local lsp_keys = {
  { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
  { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
  { "K", vim.lsp.buf.hover, desc = "Hover" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature Help"},
  -- { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
  { "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
  { "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
  { "]e", diagnostic_goto(true, "ERROR"), desc = "Next Error" },
  { "[e", diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
  { "]w", diagnostic_goto(true, "WARN"), desc = "Next Warning" },
  { "[w", diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
  {
    "<leader>cA",
    function()
      vim.lsp.buf.code_action({
        context = {
          only = {
            "source",
          },
          diagnostics = {},
        },
      })
    end,
    desc = "Source Action",
  }
}

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
      'nvim-telescope/telescope.nvim',
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
        'emmet_language_server',
        'tsserver',
        'cssls',
        'eslint',
        'pylsp',
        'marksman',
        'yamlls',
        'texlab',
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

        ["rust_analyzer"] = function ()
          lspconfig.rust_analyzer.setup {
            capabilities = capabilities,
            settings = {
              ["rust-analyzer"] = {
                -- Add clippy lints for Rust.
                checkOnSave = {
                  allFeatures = true,
                  command = "clippy",
                  extraArgs = { "--no-deps" },
                },
              },
            },
          }
        end,

      }
      require("mason-lspconfig").setup {
        handlers = handlers,
        automatic_installation = true,
        ensure_installed = ensure_installed,
      }
    end,
    keys = lsp_keys,
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
          'editorconfig-checker',
          'doctoc',
          'prettier',
          'tree-sitter-cli',
          'texlab',
          -- 'sqlls',
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
      { '<leader>ut', '<Plug>(toggle-lsp-diag-vtext)', desc = 'Lsp Vtext Toggle' },
      { '<leader>ud', function ()
        vim.diagnostic.enable()
        require("notify")("Vim Diag Enabled")
      end , desc = 'On vim diagnostics' },
      { '<leader>uD', function ()
        vim.diagnostic.disable()
        require("notify")("Vim Diag Disabled")
      end , desc = 'Off vim diagnostics' },
      { '<leader>ui', function ()
        vim.lsp.inlay_hint(0, nil)
      end , desc = 'Toggle Inlay Hints' },
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
