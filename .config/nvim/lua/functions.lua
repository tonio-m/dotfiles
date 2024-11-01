local OBSIDIAN_HOME = os.getenv("OBSIDIAN_HOME")
local VAULT_FOLDER = OBSIDIAN_HOME .. "003_vault/"
local INBOX_FOLDER = OBSIDIAN_HOME .. "000_inbox/"
local JOURNAL_FOLDER = OBSIDIAN_HOME .. "001_journal/"

function open_inbox()
    vim.cmd("NvimTreeOpen " .. INBOX_FOLDER)
end

function change_dir() vim.cmd("cd " .. OBSIDIAN_HOME) end
function vault_folder() vim.cmd("NvimTreeOpen " .. VAULT_FOLDER) end
function journal_folder() vim.cmd("NvimTreeOpen " .. JOURNAL_FOLDER) end
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

function delete_file()
  local current_file = vim.api.nvim_buf_get_name(0)
  if vim.fn.confirm("Are you sure you want to delete " .. current_file .. "?", "&y\n&N", 2) == 1 then
    os.remove(current_file)
    -- vim.api.nvim_command('bwipeout!')
    print(current_file .. " has been deleted")
  else
    print("File deletion cancelled")
  end
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

function rename_file()
  local input_opts = {
    prompt = 'New name: ',
    default = '',
    completion = nil,
  }

  vim.ui.input(input_opts, function(input)
    if input == nil or input == '' then
      print('No name was provided to rename file')
      return
    end

    local current_file = vim.api.nvim_buf_get_name(0)
    local path_only = vim.fn.fnamemodify(current_file, ":h")
    local target_file = path_only .. "/" .. input .. ".md"
    vim.notify(target_file)
    os.rename(current_file, target_file)
    vim.api.nvim_command('e ' .. target_file)
    vim.api.nvim_command('bwipeout! #')
  end)
end

function new_note(params)
  local args = params.args
  if #args == 0 then
    vim.cmd("edit " .. INBOX_FOLDER .. os.date("%Y-%m-%dT%H:%M:%S%z") .. '.md')
  else
    vim.cmd("edit " .. INBOX_FOLDER .. args .. '.md')
  end
end

function deque_inbox()
    local files = list_files_in_directory(INBOX_FOLDER)
    if files and #files > 0 then
        vim.cmd("edit " .. INBOX_FOLDER .. files[1])
    else
        print("Your inbox is empty")
    end
end

function calendar_function(day,month,year,week,dir)
    local date = os.time{year=year, month=month, day=day}
    vim.cmd("vsplit " .. JOURNAL_FOLDER .. os.date("%Y-%m-%d", date) .. '.md')
end

-- declare bridging vimscript function to use on calendar-vim plugin
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
    -- Get visual selection boundaries
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
            local current_date = os.date("*t")
            local filepath = string.format("%d-%02d-%s.md", 
                current_date.year,
                current_date.month,
                padded)
            vim.cmd("vsplit " .. JOURNAL_FOLDER .. filepath)
        end
    end
end
