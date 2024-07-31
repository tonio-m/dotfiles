require("config.lazy")
require("commands")
require("languageserver")
require("functions")

require("onedark").setup()
require("nvim-tree").setup({hijack_netrw = true})
require('llm').setup({
    timeout_ms = 10000,
    services = {
        openai = {
            model = "gpt-4o",
            api_key_name = "OPENAI_API_KEY",
            url = "https://api.openai.com/v1/chat/completions",
        },
    }
})

vim.cmd('syntax on')
vim.cmd('hi Folded ctermbg=none')
vim.cmd('hi Folded ctermfg=gray')

vim.o.tabstop = 4
vim.o.wrap = false
vim.o.number = true
vim.g.netrw_altv = 1
vim.o.shiftwidth = 4
vim.o.belloff = 'all'
vim.o.hlsearch = true
vim.o.softtabstop = 4
vim.g.netrw_banner = 0
vim.o.expandtab = true
vim.o.incsearch = true
vim.o.linebreak = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.ignorecase = true
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3
vim.o.foldmethod = 'indent'
vim.o.relativenumber = true
vim.g.netrw_browse_split = 4
vim.g.netrw_maxfilenamelen = 66
vim.o.backspace = 'indent,eol,start'
vim.opt.clipboard:append('unnamedplus')
vim.g.calendar_action = 'CalendarFunction'
vim.g.markdown_fenced_languages = {'json', 'python', 'html', 'javascript', 'bash'}


-- vim.keymap.set('n', '<leader>wn', ':Wn<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>mn', ':Mn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n' , 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'Y', 'y$', { noremap = true, silent = false })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dn', ':Dn<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '*', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>', { noremap = true, silent = false })

-- llm.nvim
vim.keymap.set("n", "<leader>g,", function() require("llm").prompt({ replace = false, service = "openai" }) end, { desc = "Prompt with openai" })
vim.keymap.set("v", "<leader>g,", function() require("llm").prompt({ replace = false, service = "openai" }) end, { desc = "Prompt with openai" })
vim.keymap.set("v", "<leader>g.", function() require("llm").prompt({ replace = true, service = "openai" }) end, { desc = "Prompt while replacing with openai" })

-- calendar stuff
vim.keymap.set('n', '<leader>cal', ':CalendarH<CR>', { noremap = true, silent = true })

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

