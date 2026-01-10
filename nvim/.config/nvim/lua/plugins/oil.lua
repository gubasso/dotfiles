return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")
    require("which-key").add({ { "-", oil.open, desc = "Open parent directory" } })
    oil.setup()
  end,
}
