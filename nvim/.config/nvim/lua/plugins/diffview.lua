return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>gD", "<cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
    { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Diffview Close" },
  },
  opts = { view = { merge_tool = { layout = "diff4_mixed" } } },
}
