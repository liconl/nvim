require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  require 'kickstart/plugins/gitsigns',

  require 'kickstart/plugins/which-key',

  require 'kickstart/plugins/comment',

  require 'kickstart/plugins/telescope',

  require 'kickstart/plugins/lspconfig',

  require 'kickstart/plugins/conform',

  require 'kickstart/plugins/cmp',

  require 'kickstart/plugins/mason',

  require 'kickstart/plugins/colorscheme',

  require 'kickstart/plugins/dressing',

  require 'kickstart/plugins/nvim-treesitter-textobjects',

  require 'kickstart/plugins/todo-comments',

  require 'kickstart/plugins/mini',

  require 'kickstart/plugins/treesitter',

  require 'kickstart/plugins/harpoon',

  require 'kickstart/plugins/lualine',

  -- require 'kickstart/plugins/copilot',

  require 'kickstart/plugins/nvim-surround',

  require 'kickstart/plugins/trouble',

  require 'kickstart/plugins/gitpad',

  require 'kickstart/plugins/supermaven',

  require 'kickstart/plugins/nvim-ts-context-commentstring',
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
