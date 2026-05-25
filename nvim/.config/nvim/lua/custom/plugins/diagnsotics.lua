return {
  -- "rachartier/tiny-inline-diagnostic.nvim",
  -- event = "VeryLazy",
  -- priority = 1000,
  -- config = function()
  --   require('tiny-inline-diagnostic').setup({
  --     preset = 'simple',
  --   })
  --   vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
  -- end,
  --
  {
    'dgagn/diagflow.nvim',
    -- event = 'LspAttach', This is what I use personnally and it works great
    opts = {
      scope = 'line',
    }
  }
}
