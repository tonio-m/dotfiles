require("config.lazy")
require("functions")
require("languageserver")

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
        model = "claude-3-5-haiku-latest"
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
vim.g.markdown_fenced_languages = {'json', 'python', 'html', 'javascript', 'bash', 'sql', 'cpp', 'lua'}

-- terminal settings
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = false })
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})

-- disable ESC in avante buffer
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'Avante',
    callback = function()
        vim.keymap.set({'n', 'o'}, '<ESC>', '<Nop>', { buffer = true })
    end
})

-- lsp stuff 
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n' , 'gd', vim.lsp.buf.definition, {})

-- journal actions 
vim.api.nvim_create_user_command('Cd', "cd %:h<CR>", {})
vim.api.nvim_create_user_command('Vf', vault_file, {})
vim.api.nvim_create_user_command('NvimTreeOpenAt', function(opts)
    require('nvim-tree.api').tree.open({
        path = opts.args,
        update_root = false
    })
end, { nargs = 1, complete = 'dir' })
vim.keymap.set('n', '<leader>nn', new_note, { noremap = true, silent = false })
vim.keymap.set('n', '<leader>dd', daily_note, { noremap = true, silent = false })
vim.keymap.set('n', '<leader>id', deque_inbox, { noremap = true, silent = false})
vim.keymap.set('n', '<leader>in', open_inbox, { noremap = true, silent = false })
vim.keymap.set('n', '<leader>va', vault_folder, { noremap = true, silent = false })
vim.keymap.set('n', '<leader>jo', journal_folder, { noremap = true, silent = false })
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
vim.keymap.set('n', '<leader>q', ':execute "silent! bwipeout!"<CR>', { noremap = true, silent = false })

-- editor stuff
vim.keymap.set('n', 'Y', 'y$', { noremap = true, silent = false }) -- line-wise yank
vim.api.nvim_create_user_command('SortByWidth', sort_by_width, { range = true }) -- sort lines by width command
vim.keymap.set('n', 'gF', ':vsp | edit <cfile><CR>', {noremap = true, silent = false}) -- shift gf = open file in the side
vim.keymap.set('v', '*', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>', { noremap = true, silent = false }) -- go to next instance of visually selected using *

-- plugins
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = false })

-- gobllm.nvim stuff
vim.keymap.set("n", "<leader>gg", gobllm.fill , {noremap = true, silent=false})
vim.keymap.set("n", "<leader>go", gobllm.open_chat, {noremap = true, silent=false})
vim.keymap.set("n", "<leader>gh", gobllm.chat_general_helper, {noremap = true, silent=false})
vim.api.nvim_create_user_command('GobllmReplace', gobllm.replace, { range = true, nargs = 1 })
vim.keymap.set("n", "<leader>gc", gobllm.chat_coding_assistant, {noremap = true, silent=false})

-- calendar stuff
vim.g.calendar_action = 'CalendarFunction'
vim.api.nvim_create_user_command('OpenDates', OpenDates, { range = true, nargs = '?' })
vim.keymap.set('n', '<leader>cal', ':CalendarVR<CR>:vertical resize 30<CR>', { noremap = true, silent = false })

-- macros
vim.fn.setreg('h', [[A
- 9 -
- 10 -
- 11 -
- 12 -
- 13 -
- 14 -
- 15 -
- 16 -
- 17 -
- 18 -
]])



--- TODO: this below is experimental, untested
local db = require('dashboard')

-- Custom banner with ASCII art
local banner = {
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[ ↓↡↓Ὺɭ↓ɿ　↶　↓↓ 🌾 ↡ ↓↶↓↡ 　 ↶↓↡↡↓↓↓↓↡ⶫ↓ ↓ 　↓↡↓⇟  ↡↓↓↓ 🌷 ↓⇟↓🌿↡Ὺɭ↓ ]],
[[ ɭ   ________  ________  ________  ________   ________  ________     ]],
[[↡   /    /   \/        \/        \/    /   \ /        \/        \↓🌿↡]],
[[ Ὺ /         /   --    /    /    /         /_/       //         /↓↓↓ ]],
[[↓↓/         /      ___/    /    /\        //         /         / ↓↓↓ ]],
[[ ↓\__/_____/\________/\________/  \______/ \________/\__/__/__/  🌿↡ ]],
[[ ⚲↓ 丿↓↓⇟↓　 ↡↓Ր ↓ ↡↓↷↓Ὺ↓🌱↓ ↓　↓↶🌾↓↶↡↡丿 ↓Ὺ ɿ⇂↓ↆ↓↓ↆ　↡↓↓↓  ⇟↓↓ ↡↡  ]],
[[]],
[[]],
[[]],
[[]],
[[]],
[[]],
}


db.setup({
    theme = 'doom',
    config = {
        header = banner,
        center = {
            {
                icon = '  ',
                desc = 'Find File                 ',
                action = 'Telescope find_files'
            },
            {
                icon = '  ',
                desc = 'Open Inbox Folder             ',
                action = 'tabnew | lua open_inbox()'
            },
            {
                icon = '  ',
                desc = 'Find Word                 ',
                action = 'Telescope live_grep'
            },
            {
                icon = '  ',
                desc = 'New File                  ',
                action = 'enew'
            },
            {
                icon = '  ',
                desc = 'Config                    ',
                action = 'e ~/.config/nvim/init.lua'
            },
            {
                icon = '  ',
                desc = 'Quit Neovim              ',
                action = 'qa'
            },
        },
        footer = {
            "tonio-m"
        }  -- Footer can be left empty
    }
})

-- Custom highlights
vim.cmd([[
    highlight DashboardHeader guifg=#6272A4
    highlight DashboardCenter guifg=#F8F8F2
    highlight DashboardShortcut guifg=#BD93F9
    highlight DashboardFooter guifg=#6272A4
]])
