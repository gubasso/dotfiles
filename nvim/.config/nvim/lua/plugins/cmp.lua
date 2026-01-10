-- nvim-cmp and all completion sources
return {
  -- Completion sources
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
    config = function()
      require("cmp-tw2css").setup()
    end,
  },

  -- Main completion engine
  {
    "hrsh7th/nvim-cmp",
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
      "windwp/nvim-autopairs",
      "jcha0713/cmp-tw2css",
    },
    keys = {
      {
        "<leader>uC",
        function()
          require("cmp").setup.buffer({ enabled = true })
        end,
        desc = "Cmp enable (show) in this buffer",
      },
      {
        "<leader>uc",
        function()
          require("cmp").setup.buffer({ enabled = false })
        end,
        desc = "Cmp disable (hide) in this buffer",
      },
    },
    config = function()
      local cmp = require("cmp")
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
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        }),
        sources = cmp.config.sources({
          { name = "cmp-tw2css" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lsp_signature_help" },
          { name = "buffer" },
          { name = "path" },
          { name = "emoji" },
          { name = "nerdfont" },
        }),
        sorting = defaults.sorting,
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
      }
      cmp.setup(opts)
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
        },
      })
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
}
