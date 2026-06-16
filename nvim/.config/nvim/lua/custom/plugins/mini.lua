return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- Minimal start screen. Lightweight: keeps the statusline, only nudges
      -- the tabline while shown, and never blocks your keymaps — press
      -- <leader>p / <leader>b etc. and they go straight through.
      local starter = require 'mini.starter'

      -- Fixed red for deletions/conflicts, kept across colorscheme reloads.
      local function set_starter_hl()
        vim.api.nvim_set_hl(0, 'StarterGitDelete', { fg = '#e06c75' })
        vim.api.nvim_set_hl(0, 'StarterHeaderInfo', { fg = '#ffffff' })
        vim.api.nvim_set_hl(0, 'StarterHeaderBranch', { fg = '#98c379' })
      end
      set_starter_hl()
      vim.api.nvim_create_autocmd('ColorScheme', { callback = set_starter_hl })

      -- Git status block: branch + changed files, one colored unit per line.
      -- Cached per cwd. Each line carries its own highlight (GitSigns* groups).
      local git_cache = {}
      local function git_block()
        local cwd = vim.fn.getcwd()
        if git_cache[cwd] == nil then
          local dir = vim.fn.shellescape(cwd)
          local inside = vim.fn.systemlist('git -C ' .. dir .. ' rev-parse --is-inside-work-tree 2>/dev/null')[1]
          local data = { branch = nil, files = {} }
          if inside == 'true' then
            local lines = vim.fn.systemlist('git -C ' .. dir .. ' -c color.ui=never status -sb 2>/dev/null')
            -- map porcelain status code -> sign + Nerd Font icon + highlight group
            local function decode(code)
              if code == '??' then
                return '+', '', 'GitSignsAdd' -- untracked (green)
              elseif code:find 'U' then
                return '!', '', 'StarterGitDelete' -- conflict
              elseif code:find 'D' then
                return '-', '', 'StarterGitDelete' -- deleted (solid red)
              end
              local staged = code:sub(1, 1) ~= ' '
              local c = staged and code:sub(1, 1) or code:sub(2, 2)
              local icon = ({ M = '', A = '', R = '', C = '', T = '' })[c] or ''
              local sign = ({ M = '~', A = '+', R = '~', C = '+', T = '~' })[c] or '~'
              -- staged -> green, unstaged modified -> yellow
              return sign, icon, staged and 'GitSignsAdd' or 'GitSignsChange'
            end
            if lines[1] then
              data.branch = lines[1]:gsub('^## ', ''):gsub('%.%.%..*$', '') -- name only
            end
            for i = 2, #lines do
              local code, rest = lines[i]:sub(1, 2), lines[i]:sub(4)
              local sign, icon, hl = decode(code)
              data.files[#data.files + 1] = { string = sign .. ' ' .. icon .. '  ' .. rest, hl = hl }
            end
          end
          git_cache[cwd] = data
        end
        return git_cache[cwd]
      end

      -- Append the git block as its own colored section at the bottom.
      local function add_git_status(content)
        local data = git_block()
        if not data.branch and #data.files == 0 then
          return content
        end
        table.insert(content, { { type = 'text', string = '', hl = 'MiniStarterSection' } })
        local title = { { type = 'text', string = 'Git status', hl = 'MiniStarterSection' } }
        if data.branch then
          title[#title + 1] = { type = 'text', string = '    ' .. data.branch, hl = 'Function' }
        end
        table.insert(content, title)
        for _, u in ipairs(data.files) do
          table.insert(content, { { type = 'text', string = u.string, hl = u.hl } })
        end
        return content
      end

      -- Prepend a Nerd Font file-type icon to each recent-file item.
      local function add_devicons(content)
        local has, devicons = pcall(require, 'nvim-web-devicons')
        if not has then
          return content
        end
        local coords = starter.content_coords(content, 'item')
        for i = #coords, 1, -1 do
          local c = coords[i]
          local item = content[c.line][c.unit].item
          if item and type(item.name) == 'string' and item.section and item.section:lower():find 'files' then
            local fname = item.name:match '^(%S+)'
            local icon, hl = devicons.get_icon(fname, fname:match '%.(%w+)$', { default = true })
            table.insert(content[c.line], c.unit, { type = 'text', string = icon .. ' ', hl = hl or 'MiniStarterItemPrefix' })
          end
        end
        return content
      end

      -- NEOVIM logo + current folder + git branch (computed at render).
      local function start_header()
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
        local branch = (git_block() or {}).branch
        local loc = cwd
        if branch and branch ~= '' then
          loc = loc .. ' on ' .. branch
        end
        local logo = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠙⢻⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⣠⣄⠀⢻⣿⣿⣿⣿⣿⡿⠀⣠⣄⠀⠀⠀⢻⣿⣿⣏⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⠀⠀⠀⠀⠰⣿⣿⠀⢸⣿⣿⣿⣿⣿⡇⠀⣿⣿⡇⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠙⠃⠀⣼⣿⣿⣿⣿⣿⣇⠀⠙⠛⠁⠀⠀⣼⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣷⣤⣄⣀⣠⣤⣾⣿⣿⣿⣿⣽⣿⣿⣦⣄⣀⣀⣤⣾⣿⣿⣿⣿⠃⠀⠀⢀⣀⠀⠀
⠰⡶⠶⠶⠶⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⠉⠉⠙⠛⠋⠀
⠀⠀⢀⣀⣠⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠷⠶⠶⠶⢤⣤⣀⠀
⠀⠛⠋⠉⠁⠀⣀⣴⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣤⣀⡀⠀⠀⠀⠀⠘⠃
⠀⠀⢀⣤⡶⠟⠉⠁⠀⠀⠉⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠉⠀⠀⠀⠉⠙⠳⠶⣄⡀⠀⠀
⠀⠀⠙⠁⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀]]
        return vim.trim(logo) .. '\n\n' .. loc
      end

      -- Recolor the path/branch line (everything that isn't the ASCII logo)
      -- so it doesn't share MiniStarterHeader with the NEOVIM glyph block.
      local function color_header(content)
        for _, c in ipairs(starter.content_coords(content, 'header')) do
          local unit = content[c.line][c.unit]
          -- info row is the only header line with a path char; logo is braille
          if unit.string:find '[~/]' then
            unit.hl = 'StarterHeaderInfo'
            -- split "<path> on <branch>" so the branch gets its own color
            local path, branch = unit.string:match '^(.-) on (.+)$'
            if branch then
              unit.string = path .. ' on '
              table.insert(content[c.line], c.unit + 1, {
                type = 'header',
                string = branch,
                hl = 'StarterHeaderBranch',
              })
            end
          end
        end
        return content
      end

      starter.setup {
        header = start_header,
        items = {
          starter.sections.recent_files(5, true, false), -- recent files in cwd, names only
        },
        footer = '',
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          color_header,
          add_devicons,
          add_git_status,
          starter.gen_hook.aligning('center', 'center'),
        },
      }

      -- `nvim .`: vim opens the directory in a buffer. cd into it, wipe that
      -- buffer, then show the start screen.
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          local arg = vim.fn.argv(0)
          if type(arg) == 'string' and arg ~= '' and vim.fn.isdirectory(arg) == 1 then
            vim.cmd('cd ' .. vim.fn.fnameescape(arg))
            vim.schedule(function()
              local buf = vim.api.nvim_get_current_buf()
              if vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
              starter.open()
            end)
          end
        end,
      })

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
