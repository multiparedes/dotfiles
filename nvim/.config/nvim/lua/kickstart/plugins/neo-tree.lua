-- -- https://github.com/nvim-neo-tree/neo-tree.nvim

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    "debugloop/telescope-undo.nvim",
  },
  lazy = false,
  keys = {
    { '<C-b>', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        local arg = vim.fn.argv(0)
        if type(arg) == 'string' and vim.fn.isdirectory(arg) == 1 then
          vim.schedule(function()
            vim.cmd('Neotree focus dir=' .. vim.fn.fnameescape(arg))
          end)
        end
      end,
    })
  end,
  opts = {
    filesystem = {
      hijack_netrw_behavior = 'disabled',
      close_if_last_window = true,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,

      window = {
        width = 30,
        position = "left",
        mappings = {
          ['h'] = 'close_node',
          ['l'] = 'open',
          ['<space>'] = {
            'toggle_node',
            nowait = false,
          },
        },
      },

      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true,
      },

      always_show = {
        ".paul",
      },

      buffers = {
        follow_current_file = {
          enabled = false,
          leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        show_unloaded = true,
      },
    },
  },
}
