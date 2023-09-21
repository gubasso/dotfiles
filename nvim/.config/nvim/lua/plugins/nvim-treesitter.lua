return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "help",
          "query",
          "rust",
          "javascript",
          "html",
          "css",
          "python",
          "svelte",
          "toml",
          "json",
          "markdown",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        autotag = { enable = true, },
        autopairs = { enable = true, },
      }

      -- -- Treesitter folding
      -- vim.wo.foldmethod = 'expr'
      -- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

    end,
  },
  { 'windwp/nvim-ts-autotag', config = true, },
}

