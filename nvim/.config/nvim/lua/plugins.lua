-- Function for highlighting the visual selection upon pressing <CR> in Visual mode
-- Open file/URL under cursor in browser (gx)
local function highlight_selection()
  vim.cmd.normal({ '"*y', bang = true })
  local text = vim.fn.getreg("*")
  text = vim.fn.escape(text, "\\/")
  text = vim.fn.substitute(text, "\n", "\\n", "g")
  local searchTerm = "\\V" .. text
  vim.fn.setreg("/", searchTerm)
  print("/" .. searchTerm)
  vim.fn.histadd("search", searchTerm)
  vim.opt.hlsearch = true
end

-- Function for highlighting the word under cursor on <leader><CR> in Normal mode
local function highlight_cword()
  local cword = vim.fn.expand("<cword>")
  local searchTerm = "\\v<" .. cword .. ">"
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

local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return {

	-- =========================
	-- Keymaps
	-- =========================
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
	},

	-- =========================
	-- UI
	-- =========================

	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss all Notifications",
			},
		},
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		},
	},

	{
		-- noicer ui
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			cmdline = { enabled = false },
			popupmenu = { backend = "cmp" },
			messages = { enabled = false },
			lsp = {
				progress = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				signature = { auto_open = { enabled = false, trigger = false } },
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
		},
		config = function(_, opts)
			local no = require("noice")
			require("which-key").add({
				{
					"<leader>snl",
					function()
						no.cmd("last")
					end,
					desc = "Noice Last Message",
				},
				{
					"<leader>snh",
					function()
						no.cmd("history")
					end,
					desc = "Noice History",
				},
				{
					"<leader>sna",
					function()
						no.cmd("all")
					end,
					desc = "Noice All",
				},
				{
					"<leader>snd",
					function()
						no.cmd("dismiss")
					end,
					desc = "Dismiss All",
				},
				{
					"<S-Enter>",
					function()
						no.redirect(vim.fn.getcmdline())
					end,
					mode = "c",
					desc = "Redirect Cmdline",
				},
			})
			no.setup(opts)
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	-- better vim.ui
	{
		"stevearc/dressing.nvim",
		opts = {},
	},

  -- status line / bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					globalstatus = true,
					section_separators = "",
					component_separators = "",
				},
			})
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local config = require("ibl.config").default_config
			config.indent.tab_char = config.indent.char
			config.scope.enabled = false
			config.indent.char = "|"
			require("ibl").setup(config)
		end,
	},

	-- =========================
	-- Treesitter
	-- =========================

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		cmd = { "TSUpdateSync" },
		dependencies = {
			{ "JoosepAlviste/nvim-ts-context-commentstring" },
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
				end,
			},
		},
		keys = { { "<c-space>", desc = "Increment selection" }, { "<bs>", desc = "Decrement selection", mode = "x" } },
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"dockerfile",
					"astro",
					"bash",
					"c",
					"css",
					"glimmer",
					"graphql",
					"html",
					"javascript",
					"jsdoc",
					"json",
					"lua",
					"luadoc",
					"luap",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"regex",
					"ron",
					"rust",
					"scss",
					"svelte",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"vue",
					"yaml",
					"toml",
					"sql",
					"latex",
				},
				sync_install = false,
				highlight = { enable = true, additional_vim_regex_highlighting = false },
				indent = { enable = true },
				auto_install = true,
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				autopairs = { enable = true },
			})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("ts_context_commentstring").setup({ enable = true, enable_autocmd = false })
		end,
	},

	-- =========================
	-- LSP
	-- =========================

	-- helper: diagnostic navigation
  { "williamboman/mason.nvim", },

	{ "neovim/nvim-lspconfig", },

	{
		"stevanmilic/nvim-lspimport",
		keys = {
			{
				"<leader>a",
				function()
					require("lspimport").import()
				end,
				noremap = true,
				desc = "LSP import",
			},
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("mason").setup()
			require("mason-lspconfig").setup()
			local ensure_installed = {
				"bashls",
				"lua_ls",
				"vimls",
				"rust_analyzer",
				"svelte",
				"html",
				"emmet_language_server",
				"ts_ls",
				"cssls",
				"eslint",
				"pyright",
				"ruff",
				"marksman",
				"yamlls",
				"texlab",
			}
			local handlers = {

				function(server_name)
					require("lspconfig")[server_name].setup({ capabilities = capabilities })
				end,

				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } }
              }
            }
          })
				end,

				["rust_analyzer"] = function()
					lspconfig.rust_analyzer.setup({
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								checkOnSave = { allFeatures = true, command = "clippy", extraArgs = { "--no-deps" } },
							},
						},
					})
				end,

				["pyright"] = function()
					lspconfig.pyright.setup({
						capabilities = capabilities,
						settings = {
							pyright = { disableOrganizeImports = true },
							python = { analysis = { ignore = { "*" } } },
						},
					})
				end,

			}

			require("mason-lspconfig").setup({
				handlers = handlers,
				automatic_installation = true,
				ensure_installed = ensure_installed,
			})

		end,
    keys = {
      { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
      -- { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
      { "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
      { "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
      { "]e", diagnostic_goto(true, "ERROR"), desc = "Next Error" },
      { "[e", diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
      { "]w", diagnostic_goto(true, "WARN"), desc = "Next Warning" },
      { "[w", diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "Source Action",
      },
    },
  },

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim" },
		config = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "MasonToolsStartingInstall",
				callback = function()
					vim.schedule(function()
						print("mason-tool-installer is starting")
					end)
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "MasonToolsUpdateCompleted",
				callback = function(e)
					vim.schedule(function()
						print(vim.inspect(e.data))
					end)
				end,
			})
			local opts = {
				ensure_installed = {
					"bash-language-server",
					"lua-language-server",
					"vim-language-server",
					"stylua",
					"shellcheck",
					"editorconfig-checker",
					"json-to-struct",
					"misspell",
					"codelldb",
					"rust-analyzer",
					"editorconfig-checker",
					"doctoc",
					"prettier",
					"tree-sitter-cli",
					"texlab",
					"flake8",
				},
				auto_update = true,
			}
			require("mason-tool-installer").setup(opts)
		end,
	},

	{
		"WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
		keys = {
			{ "<leader>ul", "<Plug>(toggle-lsp-diag)", desc = "Toggle All Lsp Diag" },
			{ "<leader>uL", "<Plug>(toggle-lsp-diag-default)", desc = "Set All Lsp to default" },
			{ "<leader>ut", "<Plug>(toggle-lsp-diag-vtext)", desc = "Lsp Vtext Toggle" },
			{
				"<leader>ud",
				function()
					vim.diagnostic.enable()
					require("notify")("Vim Diag Enabled")
				end,
				desc = "On vim diagnostics",
			},
			{
				"<leader>uD",
				function()
					vim.diagnostic.disable()
					require("notify")("Vim Diag Disabled")
				end,
				desc = "Off vim diagnostics",
			},
			{
				"<leader>ui",
				function()
					vim.lsp.inlay_hint(0, nil)
				end,
				desc = "Toggle Inlay Hints",
			},
		},
		config = function()
			require("toggle_lsp_diagnostics").init()
		end,
	},

	{
		"mhanberg/output-panel.nvim",
		event = "VeryLazy",
		opts = {},
		keys = { { "<leader>l", ":OutputPanel", desc = "Lsp OutputPanel" } },
	},

	-- =========================
	-- Editor
	-- =========================

	{ "jiangmiao/auto-pairs" },

	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local oil = require("oil")
			require("which-key").add({ { "-", oil.open, desc = "Open parent directory" } })
			oil.setup()
		end,
	},

	{ "wellle/targets.vim" },

	{
		"mzlogin/vim-markdown-toc",
		config = function()
			vim.g.vmt_fence_text = "toc"
			vim.g.vmt_cycle_list_item_markers = 1
			vim.g.vmt_fence_hidden_markdown_style = ""
		end,
	},

	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
			vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
			vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
			vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
			vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
			vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
			vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
			vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
			vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
			vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
			vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
			vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
			vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
		end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "css", "javascript", html = { mode = "foreground" } })
		end,
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	{ "nvim-lua/plenary.nvim", lazy = false },

	{ "folke/twilight.nvim", opts = {}, keys = { { "<leader>zt", "<cmd>Twilight<CR>", desc = "Twilight" } } },

	{
		"Pocco81/true-zen.nvim",
		config = function()
			local tz = require("true-zen")
			require("which-key").add({
				{
					"<leader>zn",
					function()
						local first = 0
						local last = vim.api.nvim_buf_line_count(0)
						tz.narrow(first, last)
					end,
					desc = "TZNarrow N",
				},
				{ "<leader>zf", tz.focus, desc = "TZFocus" },
				{ "<leader>zm", tz.minimalist, desc = "TZMinimalist" },
				{ "<leader>za", tz.ataraxis, desc = "TZAtaraxis" },
				{
					"<leader>zn",
					mode = "v",
					function()
						local first = vim.fn.line("v")
						local last = vim.fn.line(".")
						tz.narrow(first, last)
					end,
					desc = "TZNarrow V",
				},
			})
			tz.setup({})
		end,
	},

	{
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
	},

	{
		"echasnovski/mini.files",
		opts = {
			windows = { preview = true },
		},
		keys = {
			{
				"<c-e>",
				function()
					require("mini.files").open(vim.loop.cwd(), true)
				end,
				desc = "Curr File (mini.files)",
			},
			{
				"<c-f>",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Files (mini.files)",
			},
		},
		config = function(_, opts)
			require("mini.files").setup(opts)
			local show_dotfiles = true
			local filter_show = function(fs_entry)
				return true
			end
			local filter_hide = function(fs_entry)
				return not vim.startswith(fs_entry.name, ".")
			end
			local toggle_dotfiles = function()
				show_dotfiles = not show_dotfiles
				local new_filter = show_dotfiles and filter_show or filter_hide
				require("mini.files").refresh({ content = { filter = new_filter } })
			end
			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					local buf_id = args.data.buf_id
					vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
				end,
			})
		end,
	},

	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

	{
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
          },
        },
			})
			require("telescope").load_extension("fzf")
		end,
	},
	-- buffer remove
	{
		"echasnovski/mini.bufremove",
		config = function()
			require("which-key").add({
				{
					"<leader>bd",
					function()
						require("mini.bufremove").delete(0, false)
					end,
					desc = "Buffer Delete",
				},
			})
		end,
	},

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
		opts = {},
		cmd = "Trouble",
		keys = {
			{ "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{
				"<leader>xd",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{ "<leader>xcs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>xcl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
		},
	},
	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
		keys = {
			{
				"<s-h>",
				function()
					require("harpoon.mark").add_file()
					require("notify")("harpoon added")
				end,
				desc = "add file",
			},
			{
				"<leader>1",
				function()
					require("harpoon.ui").nav_file(1)
				end,
				desc = "File 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon.ui").nav_file(2)
				end,
				desc = "File 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon.ui").nav_file(3)
				end,
				desc = "File 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon.ui").nav_file(4)
				end,
				desc = "File 4",
			},
			{
				"<leader>5",
				function()
					require("harpoon.ui").nav_file(5)
				end,
				desc = "File 5",
			},
			{
				"<leader>6",
				function()
					require("harpoon.ui").nav_file(6)
				end,
				desc = "File 6",
			},
			{
				"<leader>7",
				function()
					require("harpoon.ui").nav_file(7)
				end,
				desc = "File 7",
			},
			{
				"<leader>8",
				function()
					require("harpoon.ui").nav_file(8)
				end,
				desc = "File 8",
			},
			{
				"<leader>9",
				function()
					require("harpoon.ui").nav_file(9)
				end,
				desc = "File 9",
			},
			{
				"<leader>ha",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "add file",
			},
			{
				"<leader>hh",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "menu",
			},
			{
				"<leader>hp",
				function()
					require("harpoon.ui").nav_prev()
				end,
				desc = "prev mark",
			},
			{
				"<leader>hn",
				function()
					require("harpoon.ui").nav_next()
				end,
				desc = "next mark",
			},
		},
		opts = {
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
		},
	},

	-- =========================
	-- Coding
	-- =========================

  -- Python
	{ "Glench/Vim-Jinja2-Syntax" },

	-- linter
	{
		"mfussenegger/nvim-lint",
		init = function()
			require("lint").linters_by_ft = { python = { "flake8" } }
		end,
	},

	-- align / tabular
	{ "junegunn/vim-easy-align" },
	{ "godlygeek/tabular" },

	{ "gpanders/editorconfig.nvim" },

	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip.loaders.from_lua").lazy_load({
					paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
				})
			end,
		},
		init = function()
			local ls = require("luasnip")
			local wk = require("which-key")
			wk.add({
				{ mode = "i", { "<c-K>", ls.expand, desc = "Expand snippet" } },
				{
					mode = { "i", "s" },
					{
						"<c-N>",
						function()
							ls.jump(1)
						end,
						desc = "Jump snippet forward",
					},
					{
						"<c-P>",
						function()
							ls.jump(-1)
						end,
						desc = "Jump snippet backward",
					},
					{
						"<c-E>",
						function()
							if ls.choice_active() then
								ls.change_choice(1)
							end
						end,
						desc = "Change snippet choice",
					},
				},
			})
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({ check_ts = true, fast_wrap = {} })
		end,
	},

	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-cmdline" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "hrsh7th/cmp-emoji" },
	{ "chrisgrieser/cmp-nerdfont" },
	{
		"jcha0713/cmp-tw2css",
		config = function()
			require("cmp-tw2css").setup()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-emoji",
			"chrisgrieser/cmp-nerdfont",
			"windwp/nvim-autopairs",
			"jcha0713/cmp-tw2css",
		},
		keys = {
			{
				"<leader>uC",
				function()
					require("cmp").setup.buffer({ enabled = true })
				end,
				desc = "Cmp enable (show) in this buffer",
			},
			{
				"<leader>uc",
				function()
					require("cmp").setup.buffer({ enabled = false })
				end,
				desc = "Cmp disable (hide) in this buffer",
			},
		},
		config = function()
			local cmp = require("cmp")
			local defaults = require("cmp.config.default")()
			local opts = {
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
				}),
				sources = cmp.config.sources({
					{ name = "cmp-tw2css" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "emoji" },
					{ name = "nerdfont" },
				}),
				sorting = defaults.sorting,
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
				},
			}
			cmp.setup(opts)
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "path" },
					{ name = "cmdline" },
				},
			})
			cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
		end,
	},

	{ "kylechui/nvim-surround", version = "*", event = "VeryLazy", config = true },
	-- comments
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = true,
		opts = { enable_autocmd = false },
	},
	{
		"numToStr/Comment.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		lazy = false,
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	-- Finds and lists all of the TODO, HACK, BUG, etc comment
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local td = require("todo-comments")
			require("which-key").add({
				{ "]t", td.jump_next, desc = "Next todo comment" },
				{ "[t", td.jump_prev, desc = "Previous todo comment" },
			})
		end,
	},

	{ "echasnovski/mini.icons" },

	-- Better text-objects
	{ "echasnovski/mini.ai", version = "*", opts = {} },

	{
		"smjonas/inc-rename.nvim",
		config = function()
			local ic = require("inc_rename")
			local wk = require("which-key")
			wk.add({
				{ "<leader>cR", ":IncRename ", desc = "Rename <new_name>`" },
				{
					"<leader>cr",
					function()
						return ":IncRename " .. vim.fn.expand("<cword>")
					end,
					desc = "Rename `curr_name`+<increment>",
					expr = true,
				},
			})
			ic.setup({ input_buffer_type = "dressing" })
		end,
	},

	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim" },
		config = true,
	},

	{
		"nvim-pack/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>cS",
				function()
					require("spectre").toggle()
				end,
				desc = "Spectre Toggle",
			},
			{
				"<leader>cw",
				function()
					require("spectre").open_visual({ select_word = true })
				end,
				desc = "Spectre Search current word",
			},
			{
				"<leader>cw",
				function()
					require("spectre").open_visual({ select_word = true })
				end,
				desc = "Spectre Search current word",
				mode = "v",
			},
			{
				"<leader>c/",
				function()
					require("spectre").open_file_search({ select_word = true })
				end,
				desc = "Spectre Search on current file",
			},
		},
	},

	{ "sindrets/diffview.nvim", opts = { view = { merge_tool = { layout = "diff4_mixed" } } } },

  { "lewis6991/gitsigns.nvim" },

	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gg", ":Git ", desc = "Git Command" },
			{ "gs", ":Git<CR>", desc = "Git Status" },
			{ "<leader>gs", ":Git<CR>", desc = "Git Status" },
			{ "<leader>gp", ":Git push<CR>", desc = "Git Push" },
			{ "<leader>gl", ":Git pull<CR>", desc = "Git Push" },
		},
	},
	-- in file diff view
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		keys = {
			{ "<leader>co", "<cmd>GitConflictChooseOurs<CR>", desc = "Choose Ours" },
			{ "<leader>ct", "<cmd>GitConflictChooseTheirs<CR>", desc = "Choose Theirs" },
			{ "<leader>cb", "<cmd>GitConflictChooseBoth<CR>", desc = "Choose Both" },
			{ "<leader>c0", "<cmd>GitConflictChooseNone<CR>", desc = "Choose None" },
			{ "]x", "<cmd>GitConflictNextConflict<CR>", desc = "Next Conflict" },
			{ "[x", "<cmd>GitConflictPrevConflict<CR>", desc = "Previous Conflict" },
			{ "<leader>cl", "<cmd>GitConflictListQf<CR>", desc = "List Conflicts in Quickfix" },
		},
		config = function()
			require("git-conflict").setup({
				default_mappings = false,
			})
		end,
	},
	{ "olrtg/nvim-emmet" },
}
