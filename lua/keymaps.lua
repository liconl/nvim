-- Netrw
vim.api.nvim_set_keymap('v', '<leader>maf', ":'<,'>normal mf<CR>", { noremap = true, silent = true, desc = 'Mark All Files' })
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
--  Window
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- Other
vim.api.nvim_set_keymap('v', '<leader>G', ':lua search_google()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cp', ':lua copy_relative_path()<CR>', { noremap = true, silent = true })
-- Get relative path
function _G.copy_relative_path()
  local relative_path = vim.fn.expand '%'
  if relative_path == '' then
    print 'No file currently open.'
    return
  end
  vim.fn.setreg('+', relative_path)
  print('Copied relative path: ' .. relative_path)
end
-- Search Google
function _G.search_google()
  local mode = vim.fn.mode()
  local _, line_start, col_start = unpack(vim.fn.getpos "'<")
  local _, line_end, col_end = unpack(vim.fn.getpos "'>")
  local lines = vim.fn.getline(line_start, line_end)
  if type(lines) == 'table' then
    lines[1] = string.sub(lines[1], col_start)
    lines[#lines] = string.sub(lines[#lines], 1, col_end)
  end
  local query = table.concat(lines, ' ')
  query = query:gsub(' ', '+'):gsub('([^%w%-%.%_%~])', function(char)
    return string.format('%%%02X', string.byte(char))
  end)
  local cmd = string.format('open https://www.google.com/search?q=%s', query)
  local cmd = string.format('open -a ChatGPT https://www.google.com/search?q=%s', query)
  os.execute(cmd)
  os.execute(cmd)
  print('Searching Google for: ' .. query)
end
