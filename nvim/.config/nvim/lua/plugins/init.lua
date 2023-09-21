return {
    { "sindrets/diffview.nvim" },
    {
      "shaunsingh/nord.nvim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
        -- load the colorscheme here
        vim.cmd([[colorscheme nord]])
      end,
    },
    {
      "nvim-lua/plenary.nvim",
      lazy = false,
    },
    { "gpanders/editorconfig.nvim" },
    { "kylechui/nvim-surround", config = true, },
    { 'numToStr/Comment.nvim', config = true, },
    { "Pocco81/true-zen.nvim", config = true, },
    { "folke/twilight.nvim", config = true, },
    { "norcalli/nvim-colorizer.lua", config = true, },
    {
      "iamcco/markdown-preview.nvim",
      build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
      "christoomey/vim-tmux-navigator",
      config = function ()
        vim.g.tmux_navigator_disable_when_zoomed = 1
        -- vim.g.tmux_navigator_preserve_zoom = 1
      end
    },
    { 'jiangmiao/auto-pairs' },
    { 'wellle/targets.vim' },
    {
      "folke/trouble.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = true,
    },
    {
      'mzlogin/vim-markdown-toc',
      config = function ()
        vim.g.vmt_fence_text = 'toc'
        vim.g.vmt_cycle_list_item_markers = 1
        vim.g.vmt_fence_hidden_markdown_style = ''
      end
    },
    {
      'preservim/vimux',
      lazy = false,
      config = function ()
        vim.cmd([[
          let g:VimuxHeight = "45"
          let g:VimuxOrientation = "h"
        ]])
      end
    },
    {
      'stevearc/oil.nvim',
      opts = {},
      -- Optional dependencies
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function ()
        require("oil").setup()
        vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
      end
    },
    {
      "mhanberg/output-panel.nvim",
      event = "VeryLazy",
      config = function()
        require("output_panel").setup()
      end
    },
}
