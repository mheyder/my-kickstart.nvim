-- VSCode/Cursor-specific Neovim configuration
-- This file is loaded when Neovim is running inside VSCode with vscode-neovim extension

-- Leader key settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

-- File navigation
vim.keymap.set('n', '<leader><leader>', function() vs.action('workbench.action.showAllEditors') end, { desc = 'Show Buffers' })
vim.keymap.set('n', '<leader>sf', function() vs.action('find-it-faster.findFiles') end, { desc = 'Search Files' })
vim.keymap.set('n', '<leader>sg', function() vs.action('find-it-faster.findWithinFiles') end, { desc = 'Search Grep' })
vim.keymap.set('n', '<leader>sw', function() 
  vim.cmd('normal! yiw') -- Yank the current word under cursor
  vs.action('find-it-faster.findWithinFiles') -- Open find-it-faster and paste the word
  vim.defer_fn(function() vs.action('workbench.action.terminal.paste') end, 100) -- Paste the word into the terminal
end, { desc = 'Search current Word' })

-- Note: Most plugins won't be loaded in VSCode mode
-- Additional VSCode-specific configurations can be added here
