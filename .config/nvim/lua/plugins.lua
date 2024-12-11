return {
    'hrsh7th/nvim-cmp',
    'tpope/vim-fugitive',
    'hrsh7th/cmp-nvim-lsp',
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-tree.lua',
    'monsonjeremy/onedark.nvim',
    'nvim-telekasten/calendar-vim',
    {'nvim-telescope/telescope.nvim', tag = '0.1.8'},
    {'nvimdev/dashboard-nvim', event = 'VimEnter'},
    {"yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      build = "make",
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        {
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    }
}
