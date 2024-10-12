require("config.lazy")
require("commands")
require("functions")
require("languageserver")

require("onedark").setup()

require('nvim-tree').setup({
    hijack_netrw = true,
})


local gobllm = require('gobllm')
gobllm.setup({})

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
-- vim.o.foldmethod = 'indent'
-- vim.o.foldmethod = 'syntax'
vim.o.relativenumber = true
vim.g.netrw_maxfilenamelen = 66
vim.o.backspace = 'indent,eol,start'
vim.opt.clipboard:append('unnamedplus')
vim.g.calendar_action = 'CalendarFunction'
vim.g.markdown_fenced_languages = {'json', 'python', 'html', 'javascript', 'bash', 'sql', 'cpp', 'lua'}
vim.cmd('syntax sync minlines=10000')


-- vim.keymap.set('n', '<leader>wn', ':Wn<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>mn', ':Mn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n' , 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'Y', 'y$', { noremap = true, silent = false })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>x', ':execute "silent! bwipeout!"<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dd', ':D<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bb', ':b#<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bn', ':bn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bp', ':b#<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dn', ':Dn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dp', ':Dp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>in', ':In<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>jo', ':Jo<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>nn', ':Nn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sn', ':Sn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>va', ':Va<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ne', ':new<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ve', ':vnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ta', ':tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>df', ':Df<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>rf', ':Rf<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '*', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>', { noremap = true, silent = false })

-- gobllm.nvim
vim.keymap.set("n", "<leader>gg", gobllm.complete, {noremap = true, silent=false})
vim.keymap.set("n", "<leader>gc", gobllm.chat, {noremap = true, silent=false})
vim.keymap.set("n", "<leader>go", gobllm.open_chat_buffer, {noremap = true, silent=false})

-- calendar stuff
vim.keymap.set('n', '<leader>cal', ':CalendarVR<CR>:vertical resize 30<CR>', { noremap = true, silent = true })

-- keymap for shift gf to do  :vsp | edit <cfile> 
vim.keymap.set('n', 'gF', ':vsp | edit <cfile><CR>', {noremap = true, silent = true})

vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
    end,
})

