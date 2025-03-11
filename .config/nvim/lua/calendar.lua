-- calendar stuff
local OBSIDIAN_HOME = os.getenv("OBSIDIAN_HOME")
local JOURNAL_FOLDER = OBSIDIAN_HOME .. "001_journal/"

function calendar_function(day,month,year,week,dir)
    local date = os.time{year=year, month=month, day=day}
    vim.cmd("vsplit " .. JOURNAL_FOLDER .. os.date("%Y-%m-%d", date) .. '.md')
end
-- vimscript bridge function to use on plugin config
vim.cmd([[
  function! CalendarFunction(day,month,year,week,dir)
    lua calendar_function(
        \ vim.fn.eval("a:day"), 
        \ vim.fn.eval("a:month"), 
        \ vim.fn.eval("a:year"), 
        \ vim.fn.eval("a:week"), 
        \ vim.fn.eval("a:dir"))
  endfunction
]])

function OpenDates()
    local current_date = os.date("*t")
    local month = current_date.month
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local start_col = vim.fn.col("'<")
    local end_col = vim.fn.col("'>")
    local mode = vim.fn.mode()
    local lines = vim.fn.getline(start_line, end_line)

    if #lines == 1 then
        lines[1] = lines[1]:sub(start_col, end_col)
    else
        lines[1] = lines[1]:sub(start_col)
        lines[#lines] = lines[#lines]:sub(1, end_col)
    end

    local result = table.concat(lines, " ")
    result = result:gsub("%*", " ")
    
    local items = vim.split(result, " ")
    items = vim.fn.reverse(items)

    for _, item in ipairs(items) do
        if item:match("%S") then
            local number = tonumber(item)
            local padded = string.format("%02d", number)
            local filepath = string.format("%d-%02d-%s.md",
                current_date.year,
                month,
                padded)
            vim.cmd("vsplit " .. JOURNAL_FOLDER .. filepath)
        end
    end
end


vim.g.calendar_action = 'CalendarFunction'

vim.api.nvim_create_autocmd("FileType", {
    pattern = "calendar",
    callback = function()
    vim.keymap.set('v', '<CR>', OpenDates, { buffer = true, noremap = true, silent = true })
    vim.keymap.set('x', '<CR>', OpenDates, { buffer = true, noremap = true, silent = true })
    end
})


vim.keymap.set('n', '<leader>cal', ':CalendarVR<CR>:vertical resize 30<CR>', { noremap = true, silent = false }) -- open calendar
