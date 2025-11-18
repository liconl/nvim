require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  require 'plugins/gitsigns',

  require 'plugins/which-key',

  require 'plugins/comment',

  require 'plugins/telescope',

  require 'plugins/lspconfig',

  require 'plugins/conform',

  require 'plugins/cmp',

  require 'plugins/mason',

  require 'plugins/colorscheme',

  require 'plugins/dressing',

  require 'plugins/nvim-treesitter-textobjects',

  require 'plugins/todo-comments',

  require 'plugins/mini',

  require 'plugins/treesitter',

  require 'plugins/harpoon',

  require 'plugins/lualine',

  require 'plugins/copilot',

  require 'plugins/nvim-surround',

  require 'plugins/trouble',

  require 'plugins/gitpad',

  require 'plugins/nvim-ts-context-commentstring',

  require 'plugins/markdown-preview',

  require 'plugins/nvim-colorizer',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
