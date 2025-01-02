-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- Define the function globally to ensure it is accessible
function _G.copy_relative_path()
  local relative_path = vim.fn.expand '%' -- Get the relative path of the current file
  if relative_path == '' then
    print 'No file currently open.'
    return
  end
  vim.fn.setreg('+', relative_path) -- Copy the path to the clipboard (default clipboard register '+')
  print('Copied relative path: ' .. relative_path)
end
-- Function to search Google with the selected text
function _G.search_google()
  local mode = vim.fn.mode()

  -- Get the visually selected text
  local _, line_start, col_start = unpack(vim.fn.getpos "'<")
  local _, line_end, col_end = unpack(vim.fn.getpos "'>")
  local lines = vim.fn.getline(line_start, line_end)

  -- Extract and concatenate the selected text
  if type(lines) == 'table' then
    lines[1] = string.sub(lines[1], col_start)
    lines[#lines] = string.sub(lines[#lines], 1, col_end)
  end
  local query = table.concat(lines, ' ')

  -- Escape the query for URL encoding
  query = query:gsub(' ', '+'):gsub('([^%w%-%.%_%~])', function(char)
    return string.format('%%%02X', string.byte(char))
  end)

  -- Open the Google search URL in the default browser
  local cmd = string.format('open https://www.google.com/search?q=%s', query)
  local cmd = string.format('open -a ChatGPT https://www.google.com/search?q=%s', query)
  os.execute(cmd)
  os.execute(cmd)
  print('Searching Google for: ' .. query)
end

-- Key mapping for <leader>G in visual mode
vim.api.nvim_set_keymap('v', '<leader>G', ':lua search_google()<CR>', { noremap = true, silent = true })
-- Key mapping for <leader>cp
vim.api.nvim_set_keymap('n', '<leader>cp', ':lua copy_relative_path()<CR>', { noremap = true, silent = true })
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
