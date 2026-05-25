-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
 {
    'DaikyXendo/nvim-material-icon',
  },

  {
    'windwp/nvim-ts-autotag',
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
      require("scrollbar.handlers.gitsigns").setup()
    end
  },

  {
    "cappyzawa/trim.nvim",
    opts={}
  },

  { 'mrjones2014/smart-splits.nvim', build = './kitty/install-kittens.bash' }
}
