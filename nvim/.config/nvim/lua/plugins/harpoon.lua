return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
  keys = {
    {
      "<s-h>",
      function()
        require("harpoon.mark").add_file()
        require("notify")("harpoon added")
      end,
      desc = "add file",
    },
    {
      "<leader>1",
      function()
        require("harpoon.ui").nav_file(1)
      end,
      desc = "File 1",
    },
    {
      "<leader>2",
      function()
        require("harpoon.ui").nav_file(2)
      end,
      desc = "File 2",
    },
    {
      "<leader>3",
      function()
        require("harpoon.ui").nav_file(3)
      end,
      desc = "File 3",
    },
    {
      "<leader>4",
      function()
        require("harpoon.ui").nav_file(4)
      end,
      desc = "File 4",
    },
    {
      "<leader>5",
      function()
        require("harpoon.ui").nav_file(5)
      end,
      desc = "File 5",
    },
    {
      "<leader>6",
      function()
        require("harpoon.ui").nav_file(6)
      end,
      desc = "File 6",
    },
    {
      "<leader>7",
      function()
        require("harpoon.ui").nav_file(7)
      end,
      desc = "File 7",
    },
    {
      "<leader>8",
      function()
        require("harpoon.ui").nav_file(8)
      end,
      desc = "File 8",
    },
    {
      "<leader>9",
      function()
        require("harpoon.ui").nav_file(9)
      end,
      desc = "File 9",
    },
    {
      "<leader>ha",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "add file",
    },
    {
      "<leader>hh",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "menu",
    },
    {
      "<leader>hp",
      function()
        require("harpoon.ui").nav_prev()
      end,
      desc = "prev mark",
    },
    {
      "<leader>hn",
      function()
        require("harpoon.ui").nav_next()
      end,
      desc = "next mark",
    },
  },
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
  },
}
