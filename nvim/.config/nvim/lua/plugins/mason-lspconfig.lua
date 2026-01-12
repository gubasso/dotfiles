local keymaps = require("core.utils.keymaps")

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "ibhagwan/fzf-lua",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    require("mason").setup()
    require("mason-lspconfig").setup()
    local ensure_installed = {
      "bashls",
      "lua_ls",
      "vimls",
      "rust_analyzer",
      "svelte",
      "html",
      "emmet_language_server",
      "ts_ls",
      "cssls",
      "eslint",
      "pyright",
      "ruff",
      "marksman",
      "yamlls",
      "texlab",
    }
    local handlers = {

      function(server_name)
        require("lspconfig")[server_name].setup({ capabilities = capabilities })
      end,

      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } }
            }
          }
        })
      end,

      ["rust_analyzer"] = function()
        lspconfig.rust_analyzer.setup({
          capabilities = capabilities,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { allFeatures = true, command = "clippy", extraArgs = { "--no-deps" } },
            },
          },
        })
      end,

      ["pyright"] = function()
        lspconfig.pyright.setup({
          capabilities = capabilities,
          settings = {
            pyright = { disableOrganizeImports = true },
            python = { analysis = { ignore = { "*" } } },
          },
        })
      end,

    }

    require("mason-lspconfig").setup({
      handlers = handlers,
      automatic_installation = true,
      ensure_installed = ensure_installed,
    })

  end,
  keys = {
    { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
    { "]d", keymaps.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[d", keymaps.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]e", keymaps.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
    { "[e", keymaps.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
    { "]w", keymaps.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
    { "[w", keymaps.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
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
    },
  },
}
