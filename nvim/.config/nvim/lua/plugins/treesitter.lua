return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- Pin to master (stable API); main branch is a complete rewrite
  build = ":TSUpdate",
  cmd = { "TSUpdateSync" },
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "master", -- Must match nvim-treesitter branch
      init = function()
        require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
      end,
    },
  },
  keys = { { "<c-space>", desc = "Increment selection" }, { "<bs>", desc = "Decrement selection", mode = "x" } },
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = {
        "dockerfile",
        "astro",
        "bash",
        "c",
        "css",
        "glimmer",
        "graphql",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "ron",
        "rust",
        "scss",
        "svelte",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
        "toml",
        "sql",
        "latex",
      },
      sync_install = false,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
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
      autopairs = { enable = true },
    })
  end,
}
