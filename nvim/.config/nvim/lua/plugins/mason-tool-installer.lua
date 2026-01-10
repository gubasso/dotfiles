return {
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
}
