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
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
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
    cmd = { "TSUpdateSync" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      ensure_installed = {
        'astro',
        "bash",
        "c",
        'css',
        'glimmer',
        'graphql',
        'html',
        "help",
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
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      sync_install = false,
      autotag = { enable = true, },
      autopairs = { enable = true, },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    },
  },
  { 'windwp/nvim-ts-autotag', opts = {} },
}
