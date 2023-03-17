return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup{
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = "which_key"
            }
          }
        },
        pickers = {
          find_files = { theme = "ivy", },
        },
      }
      require('telescope').load_extension('fzf')
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  {
    'tzachar/fuzzy.nvim',
    dependencies = 'nvim-telescope/telescope-fzf-native.nvim',
  },
  {
    'tzachar/cmp-fuzzy-buffer',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'tzachar/fuzzy.nvim'
    }
  },
  {
    'tzachar/cmp-fuzzy-path',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'tzachar/fuzzy.nvim'
    },
  }
}
