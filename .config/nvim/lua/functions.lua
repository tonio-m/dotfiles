local OBSIDIAN_HOME = os.getenv("OBSIDIAN_HOME")
local VAULT_FOLDER = OBSIDIAN_HOME .. "003_vault/"
local INBOX_FOLDER = OBSIDIAN_HOME .. "000_inbox/"
local JOURNAL_FOLDER = OBSIDIAN_HOME .. "001_journal/"
local BOOKMARKS_FOLDER = OBSIDIAN_HOME .. "002_bookmarks/"


function count_inbox_files()
    local files = list_files_in_directory(INBOX_FOLDER)
    return #files
end

function open_inbox() vim.cmd("NvimTreeOpenAt " .. INBOX_FOLDER) end
function edit_inbox() vim.cmd("e " .. INBOX_FOLDER) end
function edit_bookmarks() vim.cmd("e " .. BOOKMARKS_FOLDER) end
-- TODO: vault folder and journal folder is not really being used 
function vault_folder() vim.cmd("NvimTreeOpenAt " .. VAULT_FOLDER) end
function journal_folder() vim.cmd("NvimTreeOpenAt " .. JOURNAL_FOLDER) end
function daily_note() vim.cmd("edit " .. JOURNAL_FOLDER .. os.date("%Y-%m-%d") .. '.md') end
function next_daily_note() vim.cmd("edit " .. JOURNAL_FOLDER .. os.date("%Y-%m-%d", (os.time() + 86400)) .. '.md') end
function previous_daily_note() vim.cmd("edit " .. JOURNAL_FOLDER .. os.date("%Y-%m-%d", (os.time() - 86400)) .. '.md') end

function vault_file()
  local current_file = vim.api.nvim_buf_get_name(0)
  local filename = vim.fn.fnamemodify(current_file, ":t")
  local target_file = VAULT_FOLDER .. filename
  os.rename(current_file, target_file)
  vim.api.nvim_command('e ' .. target_file)
  vim.api.nvim_command('bwipeout! #')
end

function sort_by_width(opts)
  local command = string.format(':%d,%d! awk \'{ print length(), $0 | "sort -n | cut -d\\\\  -f2-" }\'', opts.line1, opts.line2)
  vim.cmd(command)
end

function list_files_in_directory(directory)
  local handle = io.popen('ls "' .. directory .. '"')
  local result = handle:read("*a")
  handle:close()
  local files = {}
  for file in string.gmatch(result, "[^\r\n]+") do
    table.insert(files, file)
  end
  return files
end

function new_note()
    -- vim.cmd("edit " .. INBOX_FOLDER .. os.date("%Y-%m-%dT%H:%M:%S%z") .. '.md')
    vim.cmd("edit " .. INBOX_FOLDER .. " | normal a")
end

function deque_inbox()
    local files = list_files_in_directory(INBOX_FOLDER)
    if files and #files > 0 then
        vim.cmd("edit " .. INBOX_FOLDER .. files[1])
    else
        print("Your inbox is empty")
    end
end

-- calendar stuff
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

function OpenDates(opts)
    local current_date = os.date("*t")
    local month = current_date.month
    if opts.args ~= "" then
        month = opts.args
    end
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local start_col = vim.fn.col("'<")
    local end_col = vim.fn.col("'>")
    local mode = vim.fn.mode()
    local lines = vim.fn.getline(start_line, end_line)

    -- Handle partial line selections for charwise visual mode
    if #lines == 1 then
        -- Single line partial selection
        lines[1] = lines[1]:sub(start_col, end_col)
    else
        -- Multi-line partial selection
        lines[1] = lines[1]:sub(start_col)
        lines[#lines] = lines[#lines]:sub(1, end_col)
    end

    -- Join and process text
    local result = table.concat(lines, " ")
    result = result:gsub("%*", " ")
    
    -- Split and print non-empty items
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

