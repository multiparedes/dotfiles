return {
  -- OneNord
  { 'rmehri01/onenord.nvim', branch = 'main', lazy = true },
  -- TokyoNight
  { 'folke/tokyonight.nvim', lazy = true },
  -- Catppuccin
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  -- JetBrains
  { 'AlexvZyl/nordic.nvim', lazy = true },

  -- OnedarkPro
  {
    'olimorris/onedarkpro.nvim',
  },

  {
      "nickkadutskyi/jb.nvim",
      -- lazy = false,
      -- priority = 1000,
      -- opts = {},
      -- config = function()
      --     -- require("jb").setup({transparent = true})
      --     vim.cmd("colorscheme jb")
      -- end,
  },

  -- Using Lazy
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup {
        style = 'darker'
      }
      -- enable theme
      require('onedark').load()
    end
  }
}
