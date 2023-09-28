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
require('core.autocmds')
require('core.options')
require('core.utils')

require"lazy".setup('plugins')

require('lang')

-- https://github.com/epwalsh/obsidian.nvim
-- https://github.com/jc-doyle/cmp-pandoc-references
-- improve telescope with fzy

-- lsp
  -- map https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim#mappings
-- harpooon
  -- https://github.com/ThePrimeagen/harpoon
  -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#harpoon-index
-- html
  -- https://github.com/windwp/nvim-ts-autotag
  -- https://github.com/jcha0713/cmp-tw2css
-- rust
  -- treesitter
  -- https://github.com/hrsh7th/cmp-nvim-lsp
  -- https://github.com/rcarriga/cmp-dap
  -- https://github.com/jay-babu/mason-nvim-dap.nvim
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Language-Server-Specific-Samples#rust-with-rust-toolsnvim
  -- https://github.com/williamboman/mason-lspconfig.nvim#automatic-server-setup-advanced-feature
  -- tests
    -- https://github.com/nvim-neotest/neotest
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/test/core.lua
-- lua
  -- https://github.com/hrsh7th/cmp-nvim-lua
