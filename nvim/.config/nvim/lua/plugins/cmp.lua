return {
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-path" },
  -- { "lukas-reineke/cmp-rg" },
  { "hrsh7th/cmp-emoji" },
  { "chrisgrieser/cmp-nerdfont" },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "tzachar/cmp-fuzzy-buffer",
      -- "tzachar/cmp-fuzzy-path",
      -- "lukas-reineke/cmp-rg",
      "hrsh7th/cmp-emoji",
      "chrisgrieser/cmp-nerdfont",
    },
    config = function()
      local cmp = require'cmp'
      local compare = require('cmp.config.compare')
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')

      cmp.setup({
        sorting = {
          priority_weight = 2,
          comparators = {
            require('cmp_fuzzy_buffer.compare'),
            compare.exact,
            compare.score,
            compare.offset,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          }
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources(
          {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'path' },
            { name = 'fuzzy_buffer' },
            -- { name = 'fuzzy_path'},
            -- { name = 'rg', keyword_length = 2 },
            { name = 'emoji' },
            { name = 'nerdfont' },
          },
          {
            { name = 'buffer' },
          }
        )
      })
      cmp.setup.cmdline('/', {
        sources = cmp.config.sources({
          { name = 'fuzzy_buffer' }
        })
      })
      -- cmp.setup.cmdline(':', {
      --   sources = cmp.config.sources({
      --     { name = 'fuzzy_path' }
      --   })
      -- })
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  }
}
