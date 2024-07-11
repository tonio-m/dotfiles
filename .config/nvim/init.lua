require("config.lazy")
require("lazy").setup("plugins")
require('onedark').setup()

vim.g.markdown_fenced_languages = {'json', 'python', 'html', 'javascript', 'bash'}

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
vim.o.clipboard = 'unnamedplus'
vim.o.backspace = 'indent,eol,start'

vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '*', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>', { noremap = true, silent = false })
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})

vim.api.nvim_create_user_command('Sterm', function()
  vim.cmd('sp | terminal')
end, {})
vim.api.nvim_create_user_command('Vterm', function()
  vim.cmd('vsp | terminal')
end, {})

vim.api.nvim_create_user_command('In', function()
  vim.cmd('Explore $HOME/Obsidian/marco_vault/000_inbox/')
end, {})

vim.api.nvim_create_user_command('Va', function()
  vim.cmd('Explore $HOME/Obsidian/marco_vault/003_vault/')
end, {})

vim.api.nvim_create_user_command('Jo', function()
  vim.cmd('Explore $HOME/Obsidian/marco_vault/001_journal/')
end, {})

vim.api.nvim_create_user_command('Dn', function()
  local date = os.date("%Y-%m-%d")
  vim.cmd('edit $HOME/Obsidian/marco_vault/001_journal/' .. date .. '.md')
end, {})

vim.api.nvim_create_user_command('SetTabSize', function(args)
  local n = tonumber(args.args)
  vim.opt_local.tabstop = n
  vim.opt_local.shiftwidth = n
  vim.opt_local.softtabstop = n
end, { nargs = 1 })

vim.api.nvim_create_user_command('SortByWidth', function(opts)
  local line1 = opts.line1
  local line2 = opts.line2
  local command = string.format(':%d,%d! awk \'{ print length(), $0 | "sort -n | cut -d\\\\  -f2-" }\'', line1, line2)
  vim.cmd(command)
end, { range = true })

vim.api.nvim_create_user_command('Nn', function(params)
  local current_time = os.date("%Y-%m-%dT%H:%M:%S%z")
  local args = params.args
  if #args == 0 then
    vim.cmd('edit $HOME/Obsidian/marco_vault/000_inbox/' .. current_time .. '.md')
  else
    local filename = args .. '.md'
    vim.cmd('edit $HOME/Obsidian/marco_vault/000_inbox/' .. filename)
  end
end, { nargs = '*'})

vim.api.nvim_create_user_command('Wn', function(params)
  offset = tonumber(params.args) or 0
  local week_num = tonumber(os.date('%V')) + offset
  local year = tonumber(os.date('%Y'))
  
  if week_num < 1 then
    week_num = 52 + week_num
    year = year - 1
  elseif week_num > 52 then
    week_num = week_num - 52
    year = year + 1
  end

  local filename = string.format('/Users/user/Obsidian/marco_vault/001_journal/%d-W%02d.md', year, week_num)
  if vim.fn.filereadable(filename) == 0 then
    local week_offset = offset * 604800  -- 7 days in seconds
    local days = {"sun", "mon", "tue", "wed", "thu", "fri", "sat"}
    local content = {}

    for i, day in ipairs(days) do
      local time_offset = (i - tonumber(os.date('%w'))) * 86400 + week_offset
      table.insert(content, day .. ":")
      table.insert(content, string.format('[[001_journal/%s.md]]', os.date('%Y-%m-%d', os.time() + time_offset)))
      table.insert(content, "")
    end

    vim.fn.writefile(content, filename)
  end

  vim.cmd('edit ' .. filename)
end, { nargs = '?' })
