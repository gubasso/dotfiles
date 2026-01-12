return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua",
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      "telescope", -- Use telescope profile for familiar look/feel
      winopts = {
        preview = { default = "bat" },
      },
      files = {
        hidden = true,
        follow = true,
        fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
      },
      grep = {
        hidden = true,
        follow = true,
        rg_opts = [[--column --line-number --no-heading --color=always --smart-case --hidden --follow --glob "!.git/"]],
        fzf_opts = {
          ["--delimiter"] = ":",
          ["--nth"] = "4..",              -- match only line text
          ["--scheme"] = "default",       -- avoid path-prioritizing scoring
          ["--tiebreak"] = "begin,index", -- remove length bias
        },
        actions = {
          ["ctrl-g"] = false,
          ["ctrl-i"] = { fn = require("fzf-lua").actions.grep_lgrep, reload = true },
        },
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept", -- Send all to quickfix
        },
      },
      actions = {
        files = {
          ["ctrl-t"] = require("trouble.sources.fzf").actions.open, -- Open in Trouble
        },
      },
    })

    -- Register keymaps via which-key
    require("which-key").add({
      -- File pickers
      { "<C-p>", fzf.files, desc = "Find Files" },
      { "<leader>fb", fzf.buffers, desc = "Buffers" },
      { "<leader>fa", fzf.builtin, desc = "All fzf-lua" },

      -- Grep pickers
      { "<leader>/", fzf.grep_project, desc = "Grep (fuzzy lines)" },
      {
        "<leader>sg",
        function() fzf.live_grep({ exec_empty_query = true }) end,
        desc = "Grep (regex)",
      },
      { "<leader>f<CR>", fzf.grep_cword, desc = "Grep under cursor" },

      -- LSP pickers
      {
        "gd",
        function() fzf.lsp_definitions({ jump1 = true }) end,
        desc = "Goto Definition",
      },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      {
        "gr",
        function() fzf.lsp_references({ ignore_current_line = true }) end,
        desc = "References",
      },
      {
        "gI",
        function() fzf.lsp_implementations({ jump1 = true }) end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function() fzf.lsp_typedefs({ jump1 = true }) end,
        desc = "Goto Type Definition",
      },

      -- Misc pickers
      { "<leader>:", fzf.command_history, desc = "Command History" },
      { "<leader>fh", fzf.help_tags, desc = "Help Tags" },
      { "<leader>fm", fzf.keymaps, desc = "Keymaps" },
      { "<leader>fc", fzf.commands, desc = "Available Commands" },

      -- Todo-comments (uses built-in fzf-lua support)
      { "<leader>ft", "<cmd>TodoFzfLua<CR>", desc = "Todo" },
      {
        "<leader>fT",
        function()
          require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Todo/Fix/Fixme",
      },
    })
  end,
}
