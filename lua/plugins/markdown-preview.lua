-- https://github.com/iamcco/markdown-preview.nvim
return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && npm install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_auto_close = 0
  end,
  ft = { 'markdown' },
  keys = {
    { '<leader>m', '<cmd>MarkdownPreview<CR>', desc = 'Preview Markdown' },
  },
}
