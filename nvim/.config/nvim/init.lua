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

-- organization model:
-- https://dev.to/voyeg3r/my-lazy-neovim-config-3h6o

local hostname = vim.loop.os_gethostname()

local specs = {
  { import = "plugins" },
}


if hostname == "valinor" then
  table.insert(specs, { import = "hosts.valinor" })
elseif hostname == "tumblesuse" then
  table.insert(specs, { import = "hosts.tumblesuse" })
end

require"lazy".setup(specs, {
  -- other lazy.nvim opts
})

require('core')
require('lang')
