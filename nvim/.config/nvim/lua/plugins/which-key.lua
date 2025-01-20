return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      layout = {
        height = { min = 4, max = 25 },
      }
    },
    config = function ()
      local wk = require("which-key")
      wk.add(require("keymaps.groups"))
      wk.add(require("keymaps.general"))
      wk.add({
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      })
    end,
  }
}
