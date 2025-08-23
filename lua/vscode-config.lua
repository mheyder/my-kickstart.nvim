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


-- Note: Most plugins won't be loaded in VSCode mode
-- Additional VSCode-specific configurations can be added here
