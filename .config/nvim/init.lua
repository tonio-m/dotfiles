require("config.lazy")
require("functions")
require("markdown_links")
require("languageserver")
require("init_dashboard")
require("onedark").setup()
require('nvim-tree').setup({
    hijack_netrw = true,
    actions = {
      change_dir = {
        enable = true,
        global = false,
      },
    },
})
require('avante').setup ({
    claude = {
        model = "claude-3-5-sonnet-latest",
    },
})
local gobllm = require('gobllm')
gobllm.setup({ })

-- settings
vim.o.tabstop = 4
vim.o.wrap = false
vim.o.number = true
vim.g.netrw_altv = 1
vim.o.shiftwidth = 4
vim.o.belloff = 'all'
vim.o.hlsearch = true
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.incsearch = true
vim.o.linebreak = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.ignorecase = true
vim.g.netrw_liststyle = 3
vim.o.relativenumber = true
vim.g.netrw_maxfilenamelen = 66
vim.o.backspace = 'indent,eol,start'
vim.cmd('syntax sync minlines=10000')
vim.opt.clipboard:append('unnamedplus')
vim.g.calendar_action = 'CalendarFunction'
vim.g.markdown_fenced_languages = {'json', 'python', 'html', 'javascript', 'bash', 'sql', 'cpp', 'lua'}
-- terminal settings
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = false })

-- lsp stuff 
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n' , 'gd', vim.lsp.buf.definition, {})

-- nvim-tree 
-- vim.api.nvim_create_user_command('NvimTreeOpenAt', function(opts) -- don't change root when opening nvim-tree
--     require('nvim-tree.api').tree.open({
--         path = opts.args,
--         update_root = false
--     })
-- end, { nargs = 1, complete = 'dir' })

-- journal config
vim.keymap.set('n', '<leader>nn', new_note, { noremap = true, silent = false })
vim.keymap.set('n', '<leader>dd', daily_note, { noremap = true, silent = false })
vim.keymap.set('n', '<leader>id', deque_inbox, { noremap = true, silent = false})
vim.keymap.set('n', '<leader>in', open_inbox, { noremap = true, silent = false })
vim.keymap.set('n', '<leader>dn', next_daily_note, { noremap = true, silent = false })
vim.keymap.set('n', '<leader>dp', previous_daily_note, { noremap = true, silent = false })

-- buffer/tab manipulation
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = false })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = false })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = false })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>bb', ':b#<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>bn', ':bn<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>bp', ':b#<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>ne', ':new<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>ve', ':vnew<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>ta', ':tabnew<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>rm', ':!rm "%"<CR>')

-- editor stuff
vim.keymap.set('n', 'Y', 'y$', { noremap = true, silent = false }) -- line-wise yank
vim.api.nvim_create_user_command('SortByWidth', sort_by_width, { range = true }) -- sort lines by width command
vim.keymap.set('n', 'gF', ':vsp | edit <cfile><CR>', {noremap = true, silent = false}) -- shift gf = open file in the side
vim.keymap.set('v', '*', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>', { noremap = true, silent = false }) -- go to next instance of visually selected using *

-- plugins
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>E', ':NvimTreeFindFile<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>')

-- gobllm.nvim stuff
vim.keymap.set("n", "<leader>go", gobllm.open_chat, {noremap = true, silent=false})
vim.keymap.set("v", "<leader>gr", gobllm.replace, {noremap = true, silent=false})

-- calendar stuff
vim.api.nvim_create_user_command('OpenDates', OpenDates, { range = true, nargs = '?' }) -- open dates in calendar
vim.keymap.set('n', '<leader>cal', ':CalendarVR<CR>:vertical resize 30<CR>', { noremap = true, silent = false }) -- open calendar

-- autocommands:
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'Avante',
    callback = function()
        vim.keymap.set({'n', 'o'}, '<ESC>', '<Nop>', { buffer = true })
    end
})

-- macros
vim.fn.setreg('h', [[A
- 7
- 8
- 9 
- 10 
- 11 
- 12 
- 13 
- 14 
- 15 
- 16 
- 17 
- 18 
]])
