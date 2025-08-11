local M = {}

local vim = vim
local api = vim.api
local fn = vim.fn

function M.augroup(name)
	return api.nvim_create_augroup(name, { clear = true })
end

-- ============================================================================
-- Security / sensitive files
-- ============================================================================
-- Protect common secrets/auth files by disabling swap/backup/undo/shada when opened.
-- Each entry below has a brief comment explaining what it matches.
-- Protect common secrets/auth files by disabling swap/backup/undo/shada when opened.
-- Protected patterns (pattern -> comment):
-- /dev/shm/gopass*        -> gopass temporary entries
-- *vault*                -> Ansible vault-related paths
-- ~/.ansible/tmp*        -> Ansible temporary directory
-- */secret/*             -> Any path with a 'secret' directory
-- */secrets/*            -> Any path with a 'secrets' directory
-- ~/.aws/credentials     -> AWS credentials file
-- ~/.aws/config          -> AWS config file
-- ~/.docker/config.json  -> Docker credential store
-- ~/.git-credentials     -> Git stored credentials
-- ~/.npmrc               -> npm auth/token file
-- ~/.netrc               -> netrc credentials file
-- ~/.ssh/*               -> SSH keys and configs (private keys)
-- ~/.kube/config         -> Kubernetes kubeconfig (can contain tokens)
-- ~/.azure/*             -> Azure auth* files
-- */.env                 -> .env files in project root
-- */.env.*               -> .env.* files (env variants)
local sensitive_files = {
  "/dev/shm/gopass*",
	"*vault*",
	"~/.ansible/tmp*",
	"*/secret/*",
	"*/secrets/*",
	"~/.aws/credentials",
	"~/.aws/config",
	"~/.docker/config.json",
	"~/.git-credentials",
	"~/.npmrc",
	"~/.netrc",
	"~/.ssh/*",
	"~/.kube/config",
	"~/.azure/*",
	"*/.env",
	"*/.env.*",
}

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = M.augroup("secure_sensitive_files"),
	pattern = sensitive_files,
	callback = function()
		-- Disable persistence and backups for buffers that may contain secrets
		vim.opt_local.swapfile = false
		vim.opt_local.backup = false
		vim.opt_local.writebackup = false
		vim.opt_local.undofile = false
		-- Clear shada so entries are not stored
		vim.opt_local.shada = ""
	end,
})

-- ============================================================================
-- Better UX
-- ============================================================================

-- close certain filetypes with <q>
api.nvim_create_autocmd("FileType", {
	group = M.augroup("close_with_q"),
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

-- Focus / checktime behavior (File auto-reload mechanism.)
api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" }, {
	group = M.augroup("auto_checktime"),
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
vim.api.nvim_create_autocmd("TextYankPost", {
	group = M.augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Resize splits on VimResized
-- ensures your split windows are kept evenly sized whenever overall UI size changes
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = M.augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = M.augroup("last_loc"),
	callback = function()
		local exclude = { "gitcommit" }
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Auto create directory when saving a file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = M.augroup("auto_create_dir"),
	callback = function(event)
		local match = event and event.match or ""
		if match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(match) or match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- ============================================================================
-- Plugins / tooling
-- ============================================================================

-- nvim-lint: run on BufWritePost
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = M.augroup("lint_on_save"),
	callback = function()
		require("lint").try_lint()
	end,
})

-- ============================================================================
-- Filetype mappings / small filetype fixes
-- ============================================================================

-- Google Apps Script (.gs) treated as javascript
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = M.augroup("filetype_mappings"),
	pattern = { "*.gs" },
	callback = function()
		vim.bo.filetype = "javascript"
	end,
})

-- Python + Jinja2 chaining: *.py.j2 => python.jinja2
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = M.augroup("Jinja2Python"),
	pattern = { "*.py.j2" },
	callback = function()
		vim.bo.filetype = "python.jinja2"
	end,
})

-- Text / Markdown
vim.api.nvim_create_autocmd("FileType", {
	group = M.augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
		vim.opt_local.colorcolumn = ""
		-- Buffer-local which-key mappings
		require("which-key").add({
			{ "<LocalLeader>l", ":RunYTMDLink<CR>", buffer = 0, desc = "YTMDLink: YouTube -> Markdown Link" },
			{
				"<LocalLeader>s",
				function()
					vim.opt_local.spell = not vim.opt_local.spell
					print("Spell checking: " .. (vim.bo[0].spell and "ON" or "OFF"))
				end,
				buffer = 0,
				desc = "Toggle spell checking",
			},
			{
				"<LocalLeader>p",
				function()
					vim.opt_local.spelllang = { "pt" }
				end,
				buffer = 0,
				desc = "Spelllang pt",
			},
			{
				"<LocalLeader>e",
				function()
					vim.opt_local.spelllang = { "en" }
				end,
				buffer = 0,
				desc = "Spelllang en",
			},
		})
	end,
})

return M
