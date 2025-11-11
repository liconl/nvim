-- https://github.com/nvim-lualine/lualine.nvim

-- https://github.com/nvim-lualine/lualine.nvim
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Custom function to display subdirectory instead of 'index.*'
    local function custom_filename()
      local full_path = vim.fn.expand '%:p' -- Get full path
      local filename = vim.fn.expand '%:t' -- Get file name
      local parent_dir = vim.fn.fnamemodify(full_path, ':h:t') -- Get parent folder name

      -- If the file is "index.*" or "[id]", return the parent directory name
      if filename:match '^index%..*$' or filename:match '^%[id%]%..*$' then
        return parent_dir ~= '' and parent_dir or 'index'
      end

      return filename -- Otherwise, return the normal filename
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'onelight',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { custom_filename }, -- ✅ Use custom function for filename
        lualine_c = { 'branch', 'diff', 'diagnostics' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { custom_filename }, -- ✅ Apply the same logic to inactive sections
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
