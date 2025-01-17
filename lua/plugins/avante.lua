-- https://github.com/yetone/avante.nvim

return {
  'yetone/avante.nvim',
  build = 'make BUILD_FROM_SOURCE=true luajit',
  event = 'VeryLazy',
  opts = {
    provider = 'claude',
    claude = {
      endpoint = 'https://api.anthropic.com',
      model = 'claude-3-5-sonnet-20240620',
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 4096,
      ['local'] = false,
    },
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below is optional, make sure to setup it properly if you have lazy=true
  },
}
