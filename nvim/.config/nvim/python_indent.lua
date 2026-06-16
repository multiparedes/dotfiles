-- Python indentation management
-- Detects indent width via tree-sitter block depth analysis (default: 2 spaces).
-- Provides toggle (2/4), manual :PyIndent command, and whole-buffer reformat.
-- The = / == operators use tree-sitter (see nvim-treesitter.lua).

local M = {}

-- Count how many 'block' ancestors a node has.
-- In Python's tree-sitter grammar each indented suite is a 'block' node,
-- so this directly equals the indentation depth of the line.
local function block_depth(node)
  local depth = 0
  local cur = node:parent()
  while cur do
    if cur:type() == 'block' then depth = depth + 1 end
    cur = cur:parent()
  end
  return depth
end

-- Detect indent width by correlating leading-space counts with tree-sitter depth.
-- For every indented line: unit = floor(spaces / depth). Most common unit wins.
function M.detect(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'python')
  if not ok or not parser then return 2 end
  local trees = parser:parse()
  if not trees or not trees[1] then return 2 end
  local root = trees[1]:root()

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(300, vim.api.nvim_buf_line_count(bufnr)), false)
  local votes = {}

  for i, line in ipairs(lines) do
    local spaces = #(line:match("^( *)") or "")
    if spaces > 0 then
      local row = i - 1  -- tree-sitter uses 0-indexed rows
      local node = root:named_descendant_for_range(row, spaces, row, spaces)
      if node then
        local depth = block_depth(node)
        if depth > 0 then
          local unit = math.floor(spaces / depth)
          if unit >= 2 then
            votes[unit] = (votes[unit] or 0) + 1
          end
        end
      end
    end
  end

  local max_count, detected = 0, nil
  for unit, count in pairs(votes) do
    if count > max_count then
      max_count = count
      detected = unit
    end
  end

  return detected or 2
end

-- Set indent width for a buffer
function M.set(width, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.bo[bufnr].shiftwidth = width
  vim.bo[bufnr].tabstop = width
  vim.bo[bufnr].softtabstop = width
  vim.notify("indent: " .. width .. " spaces", vim.log.levels.INFO, { title = "Python" })
end

-- Toggle between 2 and 4 spaces
function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  M.set(vim.bo[bufnr].shiftwidth == 2 and 4 or 2, bufnr)
end

-- Reindent the whole buffer via treesitter (= operator), restoring cursor
function M.format_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("normal! gg=G")
  end)
  cursor[1] = math.min(cursor[1], vim.api.nvim_buf_line_count(bufnr))
  vim.api.nvim_win_set_cursor(0, cursor)
end

local group = vim.api.nvim_create_augroup("PythonIndent", { clear = true })

-- Detect and apply indent when opening an existing Python file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  pattern = "*.py",
  callback = function(ev)
    local width = M.detect(ev.buf)
    vim.bo[ev.buf].shiftwidth = width
    vim.bo[ev.buf].tabstop = width
    vim.bo[ev.buf].softtabstop = width
  end,
})

-- Buffer-local keymaps (only active in Python buffers)
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "python",
  callback = function(ev)
    local o = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "<leader>T", function() M.toggle(ev.buf) end,
      vim.tbl_extend("force", o, { desc = "Python: toggle indent 2/4" }))
    vim.keymap.set("n", "<leader>vf", function() M.format_buffer(ev.buf) end,
      vim.tbl_extend("force", o, { desc = "Python: reindent whole buffer" }))
  end,
})

-- :PyIndent <n>  — set indent width manually
vim.api.nvim_create_user_command("PyIndent", function(args)
  local width = tonumber(args.args)
  if not width or width < 1 then
    vim.notify("Usage: PyIndent <number>", vim.log.levels.ERROR, { title = "Python" })
    return
  end
  M.set(width)
end, { nargs = 1, desc = "Set Python indentation width" })

return M
