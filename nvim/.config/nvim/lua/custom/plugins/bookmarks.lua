-- Line-level bookmarks, VSCode "Bookmarks" style.
-- Toggle a mark on any line, name/annotate it, jump next/prev, browse in a
-- picker, organize into lists. Persisted in a SQLite db across sessions.
-- Uses snacks.nvim as picker (already installed).
return {
  'LintaoAmons/bookmarks.nvim',
  tag = 'v4.0.0',
  event = 'VimEnter',
  dependencies = {
    { 'kkharji/sqlite.lua' },
    { 'folke/snacks.nvim' },
    { 'nvim-telescope/telescope.nvim' },
  },
  config = function()
    require('bookmarks').setup {
      -- SQLite db lives here by default: ~/.local/share/nvim/bookmarks.sqlite.db
      picker = { picker_backend = 'snacks' },
    }

    local map = vim.keymap.set
    map('n', '<leader>mm', '<cmd>BookmarksMark<cr>', { desc = 'Bookmark: toggle / name line' })
    map('n', '<leader>ml', '<cmd>BookmarksGoto<cr>', { desc = 'Bookmark: list / goto (picker)' })
    map('n', '<leader>mt', '<cmd>BookmarksTree<cr>', { desc = 'Bookmark: tree view' })
    map('n', '<leader>mn', '<cmd>BookmarksGotoNext<cr>', { desc = 'Bookmark: next' })
    map('n', '<leader>mp', '<cmd>BookmarksGotoPrev<cr>', { desc = 'Bookmark: prev' })
    map('n', '<leader>ms', '<cmd>BookmarksLists<cr>', { desc = 'Bookmark: switch list' })
    map('n', '<leader>mc', '<cmd>BookmarksCommands<cr>', { desc = 'Bookmark: command palette' })
  end,
}
