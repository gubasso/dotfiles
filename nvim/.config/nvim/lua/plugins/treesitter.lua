local load_textobjects = false
return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      -- disable rtp plugin, as we only need its queries for mini.ai
      -- In case other textobject modules are enabled, we will load them
      -- once nvim-treesitter is loaded
      require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
      load_textobjects = true
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync" },
    dependencies = {
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- disable rtp plugin, as we only need its queries for mini.ai
          -- In case other textobject modules are enabled, we will load them
          -- once nvim-treesitter is loaded
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          load_textobjects = true
        end,
      },
    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          'dockerfile',
          'astro',
          "bash",
          "c",
          'css',
          'glimmer',
          'graphql',
          'html',
          'javascript',
          "jsdoc",
          "json",
          'lua',
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          'python',
          "query",
          "regex",
          "ron",
          "rust",
          'scss',
          'svelte',
          'tsx',
          'typescript',
          'vim',
          "vimdoc",
          'vue',
          "yaml",
          "toml",
          "sql",
        },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        auto_install = true,
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        autopairs = { enable = true, },
      })


    end,
  },

  {
    'windwp/nvim-ts-autotag',
    config = function ()
      require('nvim-ts-autotag').setup()
    end
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function ()
      require('ts_context_commentstring').setup {
        enable = true,
        enable_autocmd = false,
      }
    end
  },

}
