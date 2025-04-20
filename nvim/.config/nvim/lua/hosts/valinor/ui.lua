return {
  -- colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    init = function()
        vim.cmd.colorscheme("catppuccin-frappe")
    end,
  },
}
