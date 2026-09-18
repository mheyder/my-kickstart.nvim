local parsers = {
  'bash',
  'c',
  'csv',
  'diff',
  'git_rebase',
  'gitcommit',
  'gitignore',
  'html',
  'ini',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'ruby',
  'sql',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ts.install(parsers)

      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      local function start(buf, lang)
        if not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        if lang == 'ruby' then
          vim.bo[buf].syntax = 'on'
        else
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end
          if vim.treesitter.language.add(lang) then
            start(args.buf, lang)
          elseif available[lang] then
            ts.install(lang):await(function()
              if vim.api.nvim_buf_is_valid(args.buf) then
                start(args.buf, lang)
              end
            end)
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      for key, query in pairs {
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
        aa = '@parameter.outer',
        ia = '@parameter.inner',
      } do
        vim.keymap.set({ 'x', 'o' }, key, function()
          select.select_textobject(query, 'textobjects')
        end)
      end

      local move = require 'nvim-treesitter-textobjects.move'
      for key, spec in pairs {
        [']m'] = { move.goto_next_start, '@function.outer' },
        [']]'] = { move.goto_next_start, '@class.outer' },
        [']M'] = { move.goto_next_end, '@function.outer' },
        [']['] = { move.goto_next_end, '@class.outer' },
        ['[m'] = { move.goto_previous_start, '@function.outer' },
        ['[['] = { move.goto_previous_start, '@class.outer' },
        ['[M'] = { move.goto_previous_end, '@function.outer' },
        ['[]'] = { move.goto_previous_end, '@class.outer' },
      } do
        vim.keymap.set({ 'n', 'x', 'o' }, key, function()
          spec[1](spec[2], 'textobjects')
        end)
      end

      local swap = require 'nvim-treesitter-textobjects.swap'
      vim.keymap.set('n', '<leader>sa', function()
        swap.swap_next '@parameter.inner'
      end)
      vim.keymap.set('n', '<leader>sA', function()
        swap.swap_previous '@parameter.inner'
      end)
    end,
  },
}
