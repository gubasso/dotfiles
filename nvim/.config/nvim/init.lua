--       _ ____   _(_)_ __ ___   | |_   _  __ _
--      | '_ \ \ / / | '_ ` _ \  | | | | |/ _` |
--      | | | \ V /| | | | | | |_| | |_| | (_| |
--      |_| |_|\_/ |_|_| |_| |_(_)_|\__,_|\__,_|

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("core") -- needs to come first

-- Solving:   Warn notify.warn position_encoding param is required in vim.lsp.util.make_position_params. Defaulting to position encoding of the first client.
-- Monkey‐patch make_position_params to default to the first client’s encoding
do
	local orig = vim.lsp.util.make_position_params
	vim.lsp.util.make_position_params = function(win_id, position_encoding)
		-- figure out the encoding: explicit param > first client > utf-16
		local enc = position_encoding
			or (vim.lsp.get_clients({ bufnr = 0 })[1] and vim.lsp.get_clients({ bufnr = 0 })[1].offset_encoding)
			or "utf-16"
		return orig(win_id, enc)
	end
end

local hostname = vim.loop.os_gethostname()

local specs = {
	{ import = "plugins" },
	{ import = "host-" .. hostname },
}

require("lazy").setup(specs, {
	-- other lazy.nvim opts
})
