-- Function for highlighting the visual selection upon pressing <CR> in Visual mode
local function highlight_selection()
  -- Yank selection into the * register
  vim.cmd.normal({ '"*y', bang = true })
  -- Read from the * register
  local text = vim.fn.getreg("*")
  -- Escape special characters (\/) and replace newlines
  text = vim.fn.escape(text, "\\/")
  text = vim.fn.substitute(text, "\n", "\\n", "g")
  -- Prepend '\V' for "very nomagic" to match literally
  local searchTerm = "\\V" .. text
  -- Set Vim's search register, print it, add to history, and enable hlsearch
  vim.fn.setreg("/", searchTerm)
  print("/" .. searchTerm)
  vim.fn.histadd("search", searchTerm)
  vim.opt.hlsearch = true
end

-- Function for highlighting the word under cursor on <leader><CR> in Normal mode
local function highlight_cword()
  -- Expand the <cword>, and wrap it with \v<...> for "very magic" mode
  local cword = vim.fn.expand("<cword>")
  local searchTerm = "\\v<" .. cword .. ">"
  -- Set Vim's search register, print it, add to history, and enable hlsearch
  vim.fn.setreg("/", searchTerm)
  print("/" .. searchTerm)
  vim.fn.histadd("search", searchTerm)
  vim.opt.hlsearch = true
end

local function open_in_browser()
  local url = vim.fn.expand("<cfile>")
  if url == "" then
    vim.notify("No file/URL under the cursor", vim.log.levels.WARN)
    return
  end
  local open_cmd = "xdg-open"
  -- Run the command as a background job (no shell escaping needed
  -- if you pass arguments as a list)
  vim.fn.jobstart({ open_cmd, url }, { detach = true })
end

return {
  {
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
        { "<leader>s", group = "Noice" },
        { "<leader>u", group = "Toggle" },
        { "<leader>x", group = "Trouble" },
        { "<leader>z", group = "Zen" },
        { "<leader>g", group = "Git" },
      })

      wk.add({
        -- simple mappings
        { "<CR>", highlight_selection, desc = "Highlighting visual selection", mode = "v" },
        { "<leader><CR>", highlight_cword, desc = "Highlighting word under cursor" },
        { "gx", open_in_browser, desc = "Open under-cursor in browser" },
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

        -- visual mode mappings (mode at parent level)
        {
          mode = "v",
          { "<A-j>", ":m '>+1<CR>gv=gv", desc = "Move selected lines down" },
          { "<A-k>", ":m '<-2<CR>gv=gv", desc = "Move selected lines up" },
          { "<", "<gv", desc = "" },
          { ">", ">gv", desc = "" },
        },

        -- insert mode mappings
        {
          mode = "i",
          { "<A-j>", "<Esc>:m .+1<CR>==gi", desc = "Move line down in Insert mode" },
          { "<A-k>", "<Esc>:m .-2<CR>==gi", desc = "Move line up in Insert mode" },
        },

        -- normal mode clipboard mappings
        {
          { "<leader>yy", '\"+yy', desc = "clipboard yy" },
          { "<leader>yw", '\"+yiw', desc = "clipboard yiw" },
          { "<leader>yl", '\"+yiW', desc = "clipboard yiW" },
          { "<leader>Y", '\"+yg_', desc = "clipboard Y" },
          { "<leader>D", '\"+D', desc = "clipboard D" },
          { "<leader>dd", '\"+dd', desc = "clipboard dd" },
          { "<leader>p", '\"+p', desc = "clipboard p" },
          { "<leader>P", '\"+P', desc = "clipboard P" },
        },

        -- normal + visual clipboard mappings
        {
          mode = { "n", "v" },
          { "<leader>y", '\"+y', desc = "clipboard y" },
          { "<leader>d", '\"+d', desc = "clipboard d" },
        },

        -- command-line mode: allow saving as sudo
        {
          mode = { "c" },
          { "w!!", "w !sudo tee > /dev/null %", desc = "Save of files as sudo" },
        },
      })

      -- provide quick access to buffer-local which-key (kept from previous config)
      vim.keymap.set("n", "<leader>?", function()
        require("which-key").show({ global = false })
      end, { desc = "Buffer Local Keymaps (which-key)" })
    end,
  },
}
