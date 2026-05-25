return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>g", ":Neogit<CR>", desc = "Open Neogit" },
  },
  config = function()
    require("neogit").setup({
      integrations = {
        diffview = true,   -- ESTA es la integración correcta
      },
    })
  end
}
