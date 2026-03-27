-- VSCode/Cursor-specific Neovim configuration
-- This file is loaded when Neovim is running inside VSCode with vscode-neovim extension

vim.opt.ignorecase = true     -- Case insensitive search
vim.opt.smartcase = true      -- Override ignorecase if search contains capitals
vim.opt.hlsearch = true       -- Highlight search results
vim.opt.incsearch = true      -- Show search matches as you type
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard

-- Timeout settings for which-key
vim.opt.timeoutlen = 300

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local vs = require('vscode')

vim.keymap.set('n', '<leader>rn', function() vs.action('vscode-neovim.restart') end, { desc = 'Restart Neovim Extension' })

-- Editor navigation
vim.keymap.set('n', '<S-h>', function() vs.action('workbench.action.previousEditorInGroup') end, { desc = 'Previous Editor' })
vim.keymap.set('n', '<S-l>', function() vs.action('workbench.action.nextEditorInGroup') end, { desc = 'Next Editor' })

-- File navigation
vim.keymap.set('n', '<leader><leader>', function() vs.action('workbench.action.showAllEditors') end, { desc = 'Show Buffers' })
vim.keymap.set('n', '<leader>sf', function() vs.action('find-it-faster.findFiles') end, { desc = 'Search Files' })
vim.keymap.set('n', '<leader>sg', function() vs.action('find-it-faster.findWithinFiles') end, { desc = 'Search Grep' })
vim.keymap.set('n', '<leader>sw', function() 
  vim.cmd('normal! yiw') -- Yank the current word under cursor
  vs.action('find-it-faster.findWithinFiles') -- Open find-it-faster and paste the word
  vim.defer_fn(function() vs.action('workbench.action.terminal.paste') end, 100) -- Paste the word into the terminal
end, { desc = 'Search current Word' })

-- Git
vim.keymap.set('n', '<leader>gg', function() vs.action('workbench.view.scm') end, { desc = 'Git Changes' })
vim.keymap.set('n', '<leader>gd', function() vs.action('git.openChange') end, { desc = 'Git Diff current file' })
vim.keymap.set('n', '<leader>goc', function() vs.action('gitlens.openCommitOnRemote') end, { desc = 'Git Open Commit on Remote' })
vim.keymap.set('n', '<leader>gof', function() vs.action('gitlens.openFileOnRemote') end, { desc = 'Git Open File on Remote' })

-- Additional useful keymappings
vim.keymap.set('n', '<leader>ct', function() vs.action('editor.cpp.toggle') end, { desc = 'Toggle Cursor Tab' })
vim.keymap.set('n', '<leader>ca', function() vs.action('editor.action.quickFix') end, { desc = 'Code Actions' })
vim.keymap.set('n', '[c', function() vs.action('editor.action.dirtydiff.previous') end, { desc = 'Previous Change' })
vim.keymap.set('n', ']c', function() vs.action('editor.action.dirtydiff.next') end, { desc = 'Next Change' })

-- Note: Most Neovim plugins don't work in VSCode/Cursor context
-- If you really need lazy.nvim in VSCode, uncomment and fix the path below:
-- local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
-- if vim.fn.isdirectory(lazypath) == 1 then
--   vim.opt.rtp:prepend(lazypath)
--   require('lazy').setup({
--     'tpope/vim-endwise',
--     { 'echasnovski/mini.surround', opts = {} },
--     { 'echasnovski/mini.ai', opts = { n_lines = 500 } },
--   })
-- end