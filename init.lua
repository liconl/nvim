-- ============================================================
-- LEADER KEY
-- ============================================================
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- ============================================================
-- OPTIONS
-- ============================================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.laststatus = 3
vim.opt.splitkeep = 'screen'
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

-- ============================================================
-- KEYMAPS
-- ============================================================
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
vim.api.nvim_set_keymap('v', '<leader>C', ':lua search_chatgpt()<CR>', { noremap = true, silent = true })
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
-- Search ChatGPT
function _G.search_chatgpt()
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
  local cmd = string.format('open -a ChatGPT https://www.google.com/search?q=%s', query)
  os.execute(cmd)
  os.execute(cmd)
  print('Searching Google for: ' .. query)
end
-- Create a custom command to open Finder in the current file's directory
vim.api.nvim_create_user_command('Open', function()
  local current_file = vim.fn.expand '%:p:h' -- Get the current file's directory
  if vim.fn.has 'mac' == 1 then
    vim.fn.system { 'open', current_file } -- macOS Finder
  else
    print 'This command is macOS specific and uses Finder.'
  end
end, {})

-- ============================================================
-- LAZY.NVIM BOOTSTRAP
-- ============================================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- PLUGINS
-- ============================================================

-- Telescope helpers (used in telescope config)
local attachments_path = '/Users/luislicon/Library/CloudStorage/GoogleDrive-licon.luisangel@gmail.com/My Drive/Obsidian /attachments'

local function is_image_file(filepath)
  local ext = filepath:lower():match '%.([^.]+)$'
  return vim.tbl_contains({ 'png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp' }, ext)
end

local function preview_image_external(filepath)
  local quoted = string.format('"%s"', filepath)
  os.execute('open ' .. quoted)
end

require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- Gitsigns ------------------------------------------------
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },

  -- Which-key ------------------------------------------------
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },

  -- Comment --------------------------------------------------
  {
    'numToStr/Comment.nvim',
    config = function()
      local prehook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      require('Comment').setup {
        padding = true,
        sticky = true,
        ignore = '^$',
        toggler = {
          line = 'gcc',
          block = 'gbc',
        },
        opleader = {
          line = 'gc',
          block = 'gb',
        },
        extra = {
          above = 'gcO',
          below = 'gco',
          eol = 'gcA',
        },
        mappings = {
          basic = true,
          extra = true,
          extended = false,
        },
        pre_hook = prehook,
        post_hook = nil,
      }
    end,
    event = 'BufReadPre',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },

  -- Telescope ------------------------------------------------
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'
      require('telescope').setup {
        defaults = {
          preview = {
            mime_hook = function(filepath, bufnr, opts)
              local is_image = function(path)
                local image_extensions = { 'png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp' }
                local ext = path:lower():match '^.+%.(.+)$'
                return vim.tbl_contains(image_extensions, ext)
              end

              if is_image(filepath) then
                local term = vim.api.nvim_open_term(bufnr, {})
                local function send_output(_, data, _)
                  for _, d in ipairs(data) do
                    vim.api.nvim_chan_send(term, d .. '\r\n')
                  end
                end

                -- Dynamically compute preview window size
                local width = vim.api.nvim_win_get_width(opts.winid)
                local height = vim.api.nvim_win_get_height(opts.winid)

                -- Adjust for font aspect ratio (terminal chars are taller)
                local adjusted_height = math.floor(height * 0.5)

                -- Launch viu with window-based dimensions
                vim.fn.jobstart({ 'viu', '-w', tostring(width), '-h', tostring(adjusted_height), filepath }, {
                  on_stdout = send_output,
                  stdout_buffered = true,
                  pty = false,
                })
              else
                require('telescope.previewers.utils').set_preview_message(bufnr, opts.winid, 'Binary cannot be previewed')
              end
            end,
          },
        },
        pickers = {
          find_files = {
            attach_mappings = function(_, map)
              map('i', '<CR>', function(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                local filepath = entry.path or entry.filename
                actions.close(prompt_bufnr)
                if is_image_file(filepath) then
                  preview_image_external(filepath)
                else
                  vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
                end
              end)
              return true
            end,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [g]rep' })
      vim.keymap.set('n', '<leader>sG', builtin.git_status, { desc = '[S]earch by [G]it Status' })
      vim.keymap.set('n', '<leader>sb', builtin.git_branches, { desc = '[S]earch by Git [b]ranches' })
      vim.keymap.set('n', '<leader>sc', builtin.git_commits, { desc = '[S]earch by Git [c]ommits' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Config -----------------------------------------------
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'antosha417/nvim-lsp-file-operations', config = true },
      {
        'folke/neodev.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP.
        { 'j-hui/fidget.nvim', opts = {} },

        -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
        { 'folke/neodev.nvim', opts = {} },
        pts = {},
      },
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local mason_lspconfig = require 'mason-lspconfig'
      local cmp_nvim_lsp = require 'cmp_nvim_lsp'

      local keymap = vim.keymap

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          opts.desc = 'Show LSP references'
          keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)

          opts.desc = 'Go to declaration'
          keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

          opts.desc = 'Show LSP definitions'
          keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)

          opts.desc = 'Show LSP implementations'
          keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)

          opts.desc = 'Show LSP type definitions'
          keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)

          opts.desc = 'See available code actions'
          keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

          opts.desc = 'Smart rename'
          keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

          opts.desc = 'Show buffer diagnostics'
          keymap.set('n', '<leader>D', '<cmd>Telescope diagnostics bufnr=0<CR>', opts)

          opts.desc = 'Show line diagnostics'
          keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)

          opts.desc = 'Go to previous diagnostic'
          keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

          opts.desc = 'Go to next diagnostic'
          keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

          opts.desc = 'Show documentation for what is under cursor'
          keymap.set('n', 'K', vim.lsp.buf.hover, opts)

          opts.desc = 'Restart LSP'
          keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts)
        end,
      })

      local capabilities = cmp_nvim_lsp.default_capabilities()

      local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end

      mason_lspconfig.setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities,
          }
        end,
        ['svelte'] = function()
          lspconfig['svelte'].setup {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              vim.api.nvim_create_autocmd('BufWritePost', {
                pattern = { '*.js', '*.ts' },
                callback = function(ctx)
                  client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
                end,
              })
            end,
          }
        end,
        ['eslint_d'] = function()
          lspconfig['eslint_d'].setup {
            settings = {
              workingDirectory = { mode = 'auto' },
            },
          }
        end,
        ['emmet_ls'] = function()
          lspconfig['emmet_ls'].setup {
            capabilities = capabilities,
            filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'svelte' },
          }
        end,
        ['lua_ls'] = function()
          lspconfig['lua_ls'].setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                diagnostics = {
                  globals = { 'vim' },
                },
                completion = {
                  callSnippet = 'Replace',
                },
              },
            },
          }
        end,
      }
    end,
  },

  -- Conform (Autoformat) -------------------------------------
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        cssreact = { 'prettier' },
        htmlreact = { 'prettier' },
        python = { 'isort', 'black' },
        svelte = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        graphql = { 'prettier' },
      },
    },
  },

  -- nvim-cmp (Autocompletion) --------------------------------
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}
      local types = require 'cmp.types'

      local function deprioritize_snippet(entry1, entry2)
        if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
          return false
        end
        if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
          return true
        end
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        sorting = {
          priority_weight = 2,
          comparators = {
            deprioritize_snippet,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.scopes,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Mason ----------------------------------------------------
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      local mason = require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'
      local mason_tool_installer = require 'mason-tool-installer'

      mason.setup {
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }

      mason_lspconfig.setup {
        ensure_installed = {
          'ts_ls',
          'html',
          'lua_ls',
          'emmet_ls',
        },
      }

      mason_tool_installer.setup {
        ensure_installed = {
          'prettier',
          'stylua',
          'isort',
          'black',
          'pylint',
          'eslint_d',
        },
      }
    end,
  },

  -- Colorscheme (Catppuccin) ---------------------------------
  {
    'catppuccin/nvim',
    priority = 150,
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup {
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        color_overrides = {
          latte = {
            rosewater = '#c14a4a',
            flamingo = '#c14a4a',
            red = '#c14a4a',
            maroon = '#c14a4a',
            pink = '#945e80',
            mauve = '#945e80',
            peach = '#c35e0a',
            yellow = '#b47109',
            green = '#6c782e',
            teal = '#4c7a5d',
            sky = '#4c7a5d',
            sapphire = '#4c7a5d',
            blue = '#45707a',
            lavender = '#45707a',
            text = '#654735',
            subtext1 = '#73503c',
            subtext0 = '#805942',
            overlay2 = '#8c6249',
            overlay1 = '#8c856d',
            overlay0 = '#a69d81',
            surface2 = '#bfb695',
            surface1 = '#d1c7a3',
            surface0 = '#e3dec3',
            base = '#f9f5d7',
            mantle = '#f0ebce',
            crust = '#e8e3c8',
          },
          mocha = {
            rosewater = '#ea6962',
            flamingo = '#ea6962',
            red = '#ea6962',
            maroon = '#ea6962',
            pink = '#d3869b',
            mauve = '#d3869b',
            peach = '#e78a4e',
            yellow = '#d8a657',
            green = '#a9b665',
            teal = '#89b482',
            sky = '#89b482',
            sapphire = '#89b482',
            blue = '#7daea3',
            lavender = '#7daea3',
            text = '#ebdbb2',
            subtext1 = '#d5c4a1',
            subtext0 = '#bdae93',
            overlay2 = '#a89984',
            overlay1 = '#928374',
            overlay0 = '#595959',
            surface2 = '#4d4d4d',
            surface1 = '#404040',
            surface0 = '#292929',
            base = '#1d2021',
            mantle = '#191b1c',
            crust = '#141617',
          },
        },
        transparent_background = false,
        show_end_of_buffer = false,
        integration_default = false,
        no_bold = true,
        no_italic = true,
        no_underline = true,
        integrations = {
          blink_cmp = {
            style = 'bordered',
          },
          snacks = {
            enabled = true,
          },
          gitsigns = true,
          native_lsp = { enabled = true, inlay_hints = { background = true } },
          semantic_tokens = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
          fidget = true,
          mason = true,
          neotest = true,
          dap_ui = true,
        },
        highlight_overrides = {
          all = function(colors)
            return {
              -- Completion menu styling
              Pmenu = { bg = colors.mantle, fg = colors.text },
              PmenuSel = { bg = colors.surface0, fg = colors.text },
              PmenuSbar = { bg = colors.surface0 },
              PmenuThumb = { bg = colors.surface2 },
              PmenuExtra = { bg = colors.mantle, fg = colors.subtext1 },

              -- Floating windows
              NormalFloat = { bg = colors.mantle },
              FloatBorder = { bg = colors.mantle, fg = colors.surface2 },
              FloatTitle = { bg = colors.mantle, fg = colors.text },

              -- Blink.cmp specific highlighting
              BlinkCmpMenu = { bg = colors.mantle, fg = colors.text },
              BlinkCmpMenuBorder = { bg = colors.mantle, fg = colors.surface2 },
              BlinkCmpMenuSelection = { bg = colors.surface0, fg = colors.text },
              BlinkCmpScrollBarThumb = { bg = colors.surface2 },
              BlinkCmpScrollBarGutter = { bg = colors.surface0 },
              BlinkCmpLabel = { bg = colors.mantle, fg = colors.text },
              BlinkCmpLabelDeprecated = { bg = colors.mantle, fg = colors.overlay0, strikethrough = true },
              BlinkCmpLabelDetail = { bg = colors.mantle, fg = colors.subtext1 },
              BlinkCmpLabelDescription = { bg = colors.mantle, fg = colors.subtext1 },
              BlinkCmpKind = { bg = colors.mantle, fg = colors.peach },
              BlinkCmpSource = { bg = colors.mantle, fg = colors.overlay1 },
              BlinkCmpGhostText = { fg = colors.overlay0, italic = true },
              BlinkCmpDoc = { bg = colors.mantle, fg = colors.text },
              BlinkCmpDocBorder = { bg = colors.mantle, fg = colors.surface2 },
              BlinkCmpDocSeparator = { bg = colors.mantle, fg = colors.surface1 },
              BlinkCmpDocCursorLine = { bg = colors.surface0 },
              BlinkCmpSignatureHelp = { bg = colors.mantle, fg = colors.text },
              BlinkCmpSignatureHelpBorder = { bg = colors.mantle, fg = colors.surface2 },
              BlinkCmpSignatureHelpActiveParameter = { bg = colors.surface0, fg = colors.peach, bold = true },

              CmpItemMenu = { fg = colors.surface2 },
              CursorLineNr = { fg = colors.text },
              GitSignsChange = { fg = colors.peach },
              LineNr = { fg = colors.overlay0 },
              LspInfoBorder = { link = 'FloatBorder' },
              VertSplit = { bg = colors.base, fg = colors.surface0 },
              WhichKeyFloat = { bg = colors.mantle },
              YankHighlight = { bg = colors.surface2 },
              FidgetTask = { fg = colors.subtext1 },
              FidgetTitle = { fg = colors.peach },

              IblIndent = { fg = colors.surface0 },
              IblScope = { fg = colors.overlay0 },

              Boolean = { fg = colors.mauve },
              Number = { fg = colors.mauve },
              Float = { fg = colors.mauve },

              PreProc = { fg = colors.mauve },
              PreCondit = { fg = colors.mauve },
              Include = { fg = colors.mauve },
              Define = { fg = colors.mauve },
              Conditional = { fg = colors.red },
              Repeat = { fg = colors.red },
              Keyword = { fg = colors.red },
              Typedef = { fg = colors.red },
              Exception = { fg = colors.red },
              Statement = { fg = colors.red },

              Error = { fg = colors.red },
              StorageClass = { fg = colors.peach },
              Tag = { fg = colors.peach },
              Label = { fg = colors.peach },
              Structure = { fg = colors.peach },
              Operator = { fg = colors.peach },
              Title = { fg = colors.peach },
              Special = { fg = colors.yellow },
              SpecialChar = { fg = colors.yellow },
              Type = { fg = colors.yellow, style = { 'bold' } },
              Function = { fg = colors.green, style = { 'bold' } },
              Delimiter = { fg = colors.subtext1 },
              Ignore = { fg = colors.subtext1 },
              Macro = { fg = colors.teal },

              TSAnnotation = { fg = colors.mauve },
              TSAttribute = { fg = colors.mauve },
              TSBoolean = { fg = colors.mauve },
              TSCharacter = { fg = colors.teal },
              TSCharacterSpecial = { link = 'SpecialChar' },
              TSComment = { link = 'Comment' },
              TSConditional = { fg = colors.red },
              TSConstBuiltin = { fg = colors.mauve },
              TSConstMacro = { fg = colors.mauve },
              TSConstant = { fg = colors.text },
              TSConstructor = { fg = colors.green },
              TSDebug = { link = 'Debug' },
              TSDefine = { link = 'Define' },
              TSEnvironment = { link = 'Macro' },
              TSEnvironmentName = { link = 'Type' },
              TSError = { link = 'Error' },
              TSException = { fg = colors.red },
              TSField = { fg = colors.blue },
              TSFloat = { fg = colors.mauve },
              TSFuncBuiltin = { fg = colors.green },
              TSFuncMacro = { fg = colors.green },
              TSFunction = { fg = colors.green },
              TSFunctionCall = { fg = colors.green },
              TSInclude = { fg = colors.red },
              TSKeyword = { fg = colors.red },
              TSKeywordFunction = { fg = colors.red },
              TSKeywordOperator = { fg = colors.peach },
              TSKeywordReturn = { fg = colors.red },
              TSLabel = { fg = colors.peach },
              TSLiteral = { link = 'String' },
              TSMath = { fg = colors.blue },
              TSMethod = { fg = colors.green },
              TSMethodCall = { fg = colors.green },
              TSNamespace = { fg = colors.yellow },
              TSNone = { fg = colors.text },
              TSNumber = { fg = colors.mauve },
              TSOperator = { fg = colors.peach },
              TSParameter = { fg = colors.text },
              TSParameterReference = { fg = colors.text },
              TSPreProc = { link = 'PreProc' },
              TSProperty = { fg = colors.blue },
              TSPunctBracket = { fg = colors.text },
              TSPunctDelimiter = { link = 'Delimiter' },
              TSPunctSpecial = { fg = colors.blue },
              TSRepeat = { fg = colors.red },
              TSStorageClass = { fg = colors.peach },
              TSStorageClassLifetime = { fg = colors.peach },
              TSStrike = { fg = colors.subtext1 },
              TSString = { fg = colors.teal },
              TSStringEscape = { fg = colors.green },
              TSStringRegex = { fg = colors.green },
              TSStringSpecial = { link = 'SpecialChar' },
              TSSymbol = { fg = colors.text },
              TSTag = { fg = colors.peach },
              TSTagAttribute = { fg = colors.green },
              TSTagDelimiter = { fg = colors.green },
              TSText = { fg = colors.green },
              TSTextReference = { link = 'Constant' },
              TSTitle = { link = 'Title' },
              TSTodo = { link = 'Todo' },
              TSType = { fg = colors.yellow, style = { 'bold' } },
              TSTypeBuiltin = { fg = colors.yellow, style = { 'bold' } },
              TSTypeDefinition = { fg = colors.yellow, style = { 'bold' } },
              TSTypeQualifier = { fg = colors.peach, style = { 'bold' } },
              TSURI = { fg = colors.blue },
              TSVariable = { fg = colors.text },
              TSVariableBuiltin = { fg = colors.mauve },

              ['@annotation'] = { link = 'TSAnnotation' },
              ['@attribute'] = { link = 'TSAttribute' },
              ['@boolean'] = { link = 'TSBoolean' },
              ['@character'] = { link = 'TSCharacter' },
              ['@character.special'] = { link = 'TSCharacterSpecial' },
              ['@comment'] = { link = 'TSComment' },
              ['@conceal'] = { link = 'Grey' },
              ['@conditional'] = { link = 'TSConditional' },
              ['@constant'] = { link = 'TSConstant' },
              ['@constant.builtin'] = { link = 'TSConstBuiltin' },
              ['@constant.macro'] = { link = 'TSConstMacro' },
              ['@constructor'] = { link = 'TSConstructor' },
              ['@debug'] = { link = 'TSDebug' },
              ['@define'] = { link = 'TSDefine' },
              ['@error'] = { link = 'TSError' },
              ['@exception'] = { link = 'TSException' },
              ['@field'] = { link = 'TSField' },
              ['@float'] = { link = 'TSFloat' },
              ['@function'] = { link = 'TSFunction' },
              ['@function.builtin'] = { link = 'TSFuncBuiltin' },
              ['@function.call'] = { link = 'TSFunctionCall' },
              ['@function.macro'] = { link = 'TSFuncMacro' },
              ['@include'] = { link = 'TSInclude' },
              ['@keyword'] = { link = 'TSKeyword' },
              ['@keyword.function'] = { link = 'TSKeywordFunction' },
              ['@keyword.operator'] = { link = 'TSKeywordOperator' },
              ['@keyword.return'] = { link = 'TSKeywordReturn' },
              ['@label'] = { link = 'TSLabel' },
              ['@math'] = { link = 'TSMath' },
              ['@method'] = { link = 'TSMethod' },
              ['@method.call'] = { link = 'TSMethodCall' },
              ['@namespace'] = { link = 'TSNamespace' },
              ['@none'] = { link = 'TSNone' },
              ['@number'] = { link = 'TSNumber' },
              ['@operator'] = { link = 'TSOperator' },
              ['@parameter'] = { link = 'TSParameter' },
              ['@parameter.reference'] = { link = 'TSParameterReference' },
              ['@preproc'] = { link = 'TSPreProc' },
              ['@property'] = { link = 'TSProperty' },
              ['@punctuation.bracket'] = { link = 'TSPunctBracket' },
              ['@punctuation.delimiter'] = { link = 'TSPunctDelimiter' },
              ['@punctuation.special'] = { link = 'TSPunctSpecial' },
              ['@repeat'] = { link = 'TSRepeat' },
              ['@storageclass'] = { link = 'TSStorageClass' },
              ['@storageclass.lifetime'] = { link = 'TSStorageClassLifetime' },
              ['@strike'] = { link = 'TSStrike' },
              ['@string'] = { link = 'TSString' },
              ['@string.escape'] = { link = 'TSStringEscape' },
              ['@string.regex'] = { link = 'TSStringRegex' },
              ['@string.special'] = { link = 'TSStringSpecial' },
              ['@symbol'] = { link = 'TSSymbol' },
              ['@tag'] = { link = 'TSTag' },
              ['@tag.attribute'] = { link = 'TSTagAttribute' },
              ['@tag.delimiter'] = { link = 'TSTagDelimiter' },
              ['@text'] = { link = 'TSText' },
              ['@text.danger'] = { link = 'TSDanger' },
              ['@text.diff.add'] = { link = 'diffAdded' },
              ['@text.diff.delete'] = { link = 'diffRemoved' },
              ['@text.emphasis'] = { link = 'TSEmphasis' },
              ['@text.environment'] = { link = 'TSEnvironment' },
              ['@text.environment.name'] = { link = 'TSEnvironmentName' },
              ['@text.literal'] = { link = 'TSLiteral' },
              ['@text.math'] = { link = 'TSMath' },
              ['@text.note'] = { link = 'TSNote' },
              ['@text.reference'] = { link = 'TSTextReference' },
              ['@text.strike'] = { link = 'TSStrike' },
              ['@text.strong'] = { link = 'TSStrong' },
              ['@text.title'] = { link = 'TSTitle' },
              ['@text.todo'] = { link = 'TSTodo' },
              ['@text.todo.checked'] = { link = 'Green' },
              ['@text.todo.unchecked'] = { link = 'Ignore' },
              ['@text.underline'] = { link = 'TSUnderline' },
              ['@text.uri'] = { link = 'TSURI' },
              ['@text.warning'] = { link = 'TSWarning' },
              ['@todo'] = { link = 'TSTodo' },
              ['@type'] = { link = 'TSType' },
              ['@type.builtin'] = { link = 'TSTypeBuiltin' },
              ['@type.definition'] = { link = 'TSTypeDefinition' },
              ['@type.qualifier'] = { link = 'TSTypeQualifier' },
              ['@uri'] = { link = 'TSURI' },
              ['@variable'] = { link = 'TSVariable' },
              ['@variable.builtin'] = { link = 'TSVariableBuiltin' },

              ['@lsp.type.class'] = { link = 'TSType' },
              ['@lsp.type.comment'] = { link = 'TSComment' },
              ['@lsp.type.decorator'] = { link = 'TSFunction' },
              ['@lsp.type.enum'] = { link = 'TSType' },
              ['@lsp.type.enumMember'] = { link = 'TSProperty' },
              ['@lsp.type.events'] = { link = 'TSLabel' },
              ['@lsp.type.function'] = { link = 'TSFunction' },
              ['@lsp.type.interface'] = { link = 'TSType' },
              ['@lsp.type.keyword'] = { link = 'TSKeyword' },
              ['@lsp.type.macro'] = { link = 'TSConstMacro' },
              ['@lsp.type.method'] = { link = 'TSMethod' },
              ['@lsp.type.modifier'] = { link = 'TSTypeQualifier' },
              ['@lsp.type.namespace'] = { link = 'TSNamespace' },
              ['@lsp.type.number'] = { link = 'TSNumber' },
              ['@lsp.type.operator'] = { link = 'TSOperator' },
              ['@lsp.type.parameter'] = { link = 'TSParameter' },
              ['@lsp.type.property'] = { link = 'TSProperty' },
              ['@lsp.type.regexp'] = { link = 'TSStringRegex' },
              ['@lsp.type.string'] = { link = 'TSString' },
              ['@lsp.type.struct'] = { link = 'TSType' },
              ['@lsp.type.type'] = { link = 'TSType' },
              ['@lsp.type.typeParameter'] = { link = 'TSTypeDefinition' },
              ['@lsp.type.variable'] = { link = 'TSVariable' },
            }
          end,
          latte = function(colors)
            return {
              IblIndent = { fg = colors.mantle },
              IblScope = { fg = colors.surface1 },

              LineNr = { fg = colors.surface1 },
            }
          end,
        },
      }

      vim.api.nvim_command 'colorscheme catppuccin'
    end,
  },

  -- Dressing -------------------------------------------------
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
  },

  -- Treesitter Textobjects -----------------------------------
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = true,
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
              ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
              ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
              ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

              ['a:'] = { query = '@property.outer', desc = 'Select outer part of an object property' },
              ['i:'] = { query = '@property.inner', desc = 'Select inner part of an object property' },
              ['l:'] = { query = '@property.lhs', desc = 'Select left part of an object property' },
              ['r:'] = { query = '@property.rhs', desc = 'Select right part of an object property' },

              ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
              ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

              ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
              ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

              ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
              ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

              ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
              ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

              ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
              ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },

              ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
              ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>na'] = '@parameter.inner',
              ['<leader>n:'] = '@property.outer',
              ['<leader>nm'] = '@function.outer',
            },
            swap_previous = {
              ['<leader>pa'] = '@parameter.inner',
              ['<leader>p:'] = '@property.outer',
              ['<leader>pm'] = '@function.outer',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = { query = '@call.outer', desc = 'Next function call start' },
              [']m'] = { query = '@function.outer', desc = 'Next method/function def start' },
              [']c'] = { query = '@class.outer', desc = 'Next class start' },
              [']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
              [']l'] = { query = '@loop.outer', desc = 'Next loop start' },
              [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
              [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
            },
            goto_next_end = {
              [']F'] = { query = '@call.outer', desc = 'Next function call end' },
              [']M'] = { query = '@function.outer', desc = 'Next method/function def end' },
              [']C'] = { query = '@class.outer', desc = 'Next class end' },
              [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
              [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
            },
            goto_previous_start = {
              ['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
              ['[m'] = { query = '@function.outer', desc = 'Prev method/function def start' },
              ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
              ['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
              ['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
            },
            goto_previous_end = {
              ['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
              ['[M'] = { query = '@function.outer', desc = 'Prev method/function def end' },
              ['[C'] = { query = '@class.outer', desc = 'Prev class end' },
              ['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
              ['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
            },
          },
        },
      }

      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
    end,
  },

  -- Todo Comments --------------------------------------------
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- Mini -----------------------------------------------------
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
    end,
  },

  -- Treesitter -----------------------------------------------
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'javascript', 'lua', 'luadoc', 'markdown', 'typescript', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- Harpoon --------------------------------------------------
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = '[a]dd to Harpoon' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = '[H]arpoon Menu' })
      vim.keymap.set('n', '<C-j>', function()
        harpoon:list():select(1)
      end, { desc = '[1] item in Harpoon' })
      vim.keymap.set('n', '<C-k>', function()
        harpoon:list():select(2)
      end, { desc = '[2] item in Harpoon' })
      vim.keymap.set('n', '<C-l>', function()
        harpoon:list():select(3)
      end, { desc = '[3] item in Harpoon' })
      -- Actual key map is <C-;>
      -- Remap iterm to ttt
      vim.keymap.set('n', 'ttt', function()
        harpoon:list():select(4)
      end, { desc = '[4] item in Harpoon' })
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end, { desc = '[H]arpoon Menu' })
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end, { desc = '[H]arpoon Menu' })
    end,
  },

  -- Lualine --------------------------------------------------
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local function custom_filename()
        local full_path = vim.fn.expand '%:p'
        local filename = vim.fn.expand '%:t'
        local parent_dir = vim.fn.fnamemodify(full_path, ':h:t')

        if filename:match '^index%..*$' or filename:match '^%[id%]%..*$' then
          return parent_dir ~= '' and parent_dir or 'index'
        end

        return filename
      end

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'onelight',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
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
          lualine_b = { custom_filename },
          lualine_c = { 'branch', 'diff', 'diagnostics' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { custom_filename },
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
  },

  -- nvim-surround --------------------------------------------
  {
    'kylechui/nvim-surround',
    version = '*',
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
  },

  -- Trouble --------------------------------------------------
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/todo-comments.nvim' },
    opts = {
      focus = true,
    },
    cmd = 'Trouble',
    keys = {
      { '<leader>tw', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Open trouble workspace diagnostics' },
      { '<leader>td', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Open trouble document diagnostics' },
      { '<leader>tq', '<cmd>Trouble quickfix toggle<CR>', desc = 'Open trouble quickfix list' },
      { '<leader>tl', '<cmd>Trouble loclist toggle<CR>', desc = 'Open trouble location list' },
      { '<leader>tt', '<cmd>Trouble todo toggle<CR>', desc = 'Open todos in trouble' },
    },
  },

  -- Gitpad ---------------------------------------------------
  {
    'yujinyuz/gitpad.nvim',
    config = function()
      require('gitpad').setup {}
    end,
    keys = {
      {
        '<leader>pp',
        function()
          require('gitpad').toggle_gitpad()
        end,
        desc = 'gitpad project',
      },
      {
        '<leader>pb',
        function()
          require('gitpad').toggle_gitpad_branch()
        end,
        desc = 'gitpad branch',
      },
      {
        '<leader>pvs',
        function()
          require('gitpad').toggle_gitpad_branch { window_type = 'split', split_win_opts = { split = 'right' } }
        end,
        desc = 'gitpad branch vertical split',
      },
      {
        '<leader>pd',
        function()
          local date_filename = 'daily-' .. os.date '%Y-%m-%d.md'
          require('gitpad').toggle_gitpad { filename = date_filename }
        end,
        desc = 'gitpad daily notes',
      },
      {
        '<leader>pf',
        function()
          local filename = vim.fn.expand '%:p'
          if filename == '' then
            vim.notify 'empty bufname'
            return
          end
          filename = vim.fn.pathshorten(filename, 2) .. '.md'
          require('gitpad').toggle_gitpad { filename = filename }
        end,
        desc = 'gitpad per file notes',
      },
    },
  },

  -- nvim-ts-context-commentstring ----------------------------
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false,
    },
  },

  -- Markdown Preview -----------------------------------------
  {
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
  },

  -- nvim-colorizer -------------------------------------------
  {
    'norcalli/nvim-colorizer.lua',
  },
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

-- ============================================================
-- IMAGE PREVIEW (macOS)
-- ============================================================
local function is_image(filepath)
  local ext = filepath:lower():match '%.([^.]+)$'
  return vim.tbl_contains({ 'png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp' }, ext)
end

local function open_in_preview(filepath)
  local quoted = string.format('"%s"', filepath)
  os.execute('open ' .. quoted)
end

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)

    if vim.fn.isdirectory(file) == 0 and is_image(file) then
      if not vim.b._image_previewed then
        vim.b._image_previewed = true

        vim.defer_fn(function()
          vim.cmd 'Ex'
          open_in_preview(file)
        end, 10)
      end
    end
  end,
})
