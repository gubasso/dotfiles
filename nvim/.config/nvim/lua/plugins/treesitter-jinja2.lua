return {
  "geigerzaehler/tree-sitter-jinja2",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  build = ":TSUpdate",
  config = function()
    -- Register the jinja2 parser for nvim-treesitter master branch
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.jinja2 = {
      install_info = {
        url = "https://github.com/geigerzaehler/tree-sitter-jinja2",
        branch = "main",
        files = { "src/parser.c" },
      },
      filetype = "jinja2",
    }
    -- Filetype detection for .py.j2 -> python.jinja2 (enables both Python and Jinja2 highlighting)
    vim.filetype.add({
      pattern = {
        [".*%.py%.j2"] = "python.jinja2",
      },
    })
  end,
}
