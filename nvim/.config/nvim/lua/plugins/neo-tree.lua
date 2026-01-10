return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  config = function()
    local wk = require("which-key")
    local ntcmd = require("neo-tree.command")
    wk.add({
      {
        "<leader>ee",
        function()
          ntcmd.execute({ toggle = true, source = "filesystem", position = "left" })
        end,
        desc = "Files (Neotree)",
      },
      {
        "<leader>e.",
        function()
          ntcmd.execute({ toggle = true, source = "filesystem", position = "current" })
        end,
        desc = "Files (netrw style)",
      },
      {
        "<leader>ef",
        function()
          ntcmd.execute({ toggle = true, source = "filesystem", position = "left", reveal = true })
        end,
        desc = "Curr File (Neotree)",
      },
      {
        "<leader>eb",
        function()
          ntcmd.execute({ toggle = true, source = "buffers", position = "left" })
        end,
        desc = "Buffers",
      },
      {
        "<leader>eg",
        function()
          ntcmd.execute({ toggle = true, source = "git_status", position = "left" })
        end,
        desc = "Git Status",
      },
    })
    local opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      event_handlers = {
        {
          event = "neo_tree_popup_input_ready",
          handler = function(args)
            vim.cmd("stopinsert")
            vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
          end,
        },
      },
      filesystem = {
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      window = {
        position = "current",
        mappings = {
          ["e"] = function()
            vim.api.nvim_exec("Neotree focus filesystem left", true)
          end,
          ["b"] = function()
            vim.api.nvim_exec("Neotree focus buffers left", true)
          end,
          ["g"] = function()
            vim.api.nvim_exec("Neotree focus git_status left", true)
          end,
          ["o"] = "system_open",
        },
      },
      deactivate = function()
        vim.cmd([[Neotree close]])
      end,
      commands = {
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          path = vim.fn.shellescape(path, 1)
          vim.api.nvim_command("silent !open -g " .. path)
          vim.api.nvim_command("silent !xdg-open " .. path)
        end,
      },
    }
    require("neo-tree").setup(opts)
  end,
}
