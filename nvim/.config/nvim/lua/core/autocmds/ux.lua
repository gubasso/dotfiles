-- UX improvements: Quality of life autocmds
local api = vim.api
local fn = vim.fn

local function augroup(name)
  return api.nvim_create_augroup(name, { clear = true })
end

-- Close certain filetypes with <q>
api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "fugitive",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", function()
      api.nvim_command("close")
    end, { buffer = event.buf, silent = true })
  end,
})

-- Focus / checktime behavior (File auto-reload mechanism)
api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" }, {
  group = augroup("auto_checktime"),
  callback = function()
    -- skip cmdwin
    if fn.getcmdwintype() ~= "" then
      return
    end
    -- skip command/replace/prompt/terminal modes
    local mode = api.nvim_get_mode().mode
    if mode:match("^[cr!t]") then
      return
    end
    api.nvim_command("checktime")
  end,
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits on VimResized
-- Ensures split windows are kept evenly sized when UI size changes
api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last location when opening a buffer
api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local exclude = { "gitcommit" }
    local buf = api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = api.nvim_buf_get_mark(buf, '"')
    local lcount = api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto create directory when saving a file
api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    local match = event and event.match or ""
    if match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(match) or match
    fn.mkdir(fn.fnamemodify(file, ":p:h"), "p")
  end,
})
