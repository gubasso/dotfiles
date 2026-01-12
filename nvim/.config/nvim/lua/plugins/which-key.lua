local keymaps = require("core.utils.keymaps")

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    layout = {
      height = { min = 4, max = 25 },
    },
  },
  config = function()
    local wk = require("which-key")
    -- Defaults --------------------------------------------
    wk.setup({})

    -- Groups ----------------------------------------------
    wk.add({
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>n", group = "Notes" },
      { "<leader>s", group = "Noice" },
      { "<leader>u", group = "Toggle" },
      { "<leader>x", group = "Trouble" },
      { "<leader>z", group = "Zen" },
      { "<leader>g", group = "Git" },
    })


    wk.add({
      { "<CR>", keymaps.highlight_selection, desc = "Highlighting visual selection", mode = "v" },
      { "<leader><CR>", keymaps.highlight_cword, desc = "Highlighting word under cursor" },
      { "gx", keymaps.system_open_under_cursor, desc = "Open under-cursor (system opener)" },
      {
        "<leader>nm",
        function()
          require("core.usercmds.md_new").prompt()
        end,
        desc = "New Markdown note",
      },
      { "<leader>w", ":wa<CR>", desc = "Save all" },
      { "<leader>q", "<cmd>wa<CR><cmd>q<CR>", desc = "Save all and Quit" },
      { "<leader><tab>", "<cmd>b#<CR>", desc = "Switch to alternate buffer" },
      { "<c-c>", ":set hlsearch!<cr>", desc = "Toggle hlsearch" },
      { "<C-Up>", "<cmd>resize +2<cr>", desc = "Increase window height" },
      { "<C-Down>", "<cmd>resize -2<cr>", desc = "Decrease window height" },
      { "<C-Left>", "<cmd>vertical resize -2<cr>", desc = "Decrease window width" },
      { "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Increase window width" },
      { "<A-j>", "<cmd>m .+1<cr>==", desc = "Move line down" },
      { "<A-k>", "<cmd>m .-2<cr>==", desc = "Move line up" },

      {
        mode = "v",
        { "<A-j>", ":m '>+1<CR>gv=gv", desc = "Move selected lines down" },
        { "<A-k>", ":m '<-2<CR>gv=gv", desc = "Move selected lines up" },
        { "<", "<gv", desc = "" },
        { ">", ">gv", desc = "" },
      },

      {
        mode = "i",
        { "<A-j>", "<Esc>:m .+1<CR>==gi", desc = "Move line down in Insert mode" },
        { "<A-k>", "<Esc>:m .-2<CR>==gi", desc = "Move line up in Insert mode" },
      },

      {
        { "<leader>yy", '"+yy', desc = "clipboard yy" },
        { "<leader>yw", '"+yiw', desc = "clipboard yiw" },
        { "<leader>yl", '"+yiW', desc = "clipboard yiW" },
        { "<leader>Y", '"+yg_', desc = "clipboard Y" },
        { "<leader>D", '"+D', desc = "clipboard D" },
        { "<leader>dd", '"+dd', desc = "clipboard dd" },
        { "<leader>p", '"+p', desc = "clipboard p" },
        { "<leader>P", '"+P', desc = "clipboard P" },
      },

      {
        mode = { "n", "v" },
        { "<leader>y", '"+y', desc = "clipboard y" },
        { "<leader>d", '"+d', desc = "clipboard d" },
      },

      {
        mode = { "c" },
        { "w!!", "w !sudo tee > /dev/null %", desc = "Save of files as sudo" },
      },
    })

    vim.keymap.set("n", "<leader>?", function()
      require("which-key").show({ global = false })
    end, { desc = "Buffer Local Keymaps (which-key)" })
  end,
}
