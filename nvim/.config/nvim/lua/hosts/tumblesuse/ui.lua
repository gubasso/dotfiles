return {
  -- colorscheme
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        -- Options are "soft", "medium" (default) or "hard".
        background = "hard",
      })
      vim.cmd([[colorscheme everforest]])
    end,
  },
}
