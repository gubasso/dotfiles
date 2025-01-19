return {
  -- colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    init = function()
        vim.cmd.colorscheme("tokyonight-moon")
    end,
  },
}
