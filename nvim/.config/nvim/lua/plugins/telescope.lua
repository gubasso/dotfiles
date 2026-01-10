return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function()
    local tlb = require("telescope.builtin")
    require("which-key").add({
      { "<c-p>", tlb.find_files, desc = "Find Files" },
      {
        "gd",
        function()
          tlb.lsp_definitions({ reuse_win = true })
        end,
        desc = "Goto Definition",
      },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gr", tlb.lsp_references, desc = "References" },
      {
        "gI",
        function()
          tlb.lsp_implementations({ reuse_win = true })
        end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function()
          tlb.lsp_type_definitions({ reuse_win = true })
        end,
        desc = "Goto T[y]pe Definition",
      },
      { "<leader>/", tlb.live_grep, desc = "Grep" },
      { "<leader>:", tlb.command_history, desc = "Command History" },
      { "<leader>f<CR>", tlb.grep_string, desc = "Grep under cursor" },
      { "<leader>fa", ":Telescope<CR>", desc = "All Telescope" },
      { "<leader>fb", tlb.buffers, desc = "Buffers" },
      { "<leader>fh", tlb.help_tags, desc = "Help Tags" },
      { "<leader>fm", tlb.keymaps, desc = "Keymaps" },
      { "<leader>fc", tlb.commands, desc = "Available Commands" },
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Todo" },
      { "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme" },
    })

    local trouble = require("trouble.sources.telescope")
    local telescope = require("telescope")
    local telescopeConfig = require('telescope.config')
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    table.insert(vimgrep_arguments, '--hidden')
    table.insert(vimgrep_arguments, '--follow')
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")
    telescope.setup({
      defaults = {
        vimgrep_arguments = vimgrep_arguments,
        mappings = {
          i = { ["<c-t>"] = trouble.open, ["<c-h>"] = "which_key" },
          n = { ["<c-t>"] = trouble.open },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          follow = true,
          file_ignore_patterns = { "%.git/" },
        },
      },
    })
    require("telescope").load_extension("fzf")
  end,
}
