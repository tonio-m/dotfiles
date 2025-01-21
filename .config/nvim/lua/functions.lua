local OBSIDIAN_HOME = os.getenv("OBSIDIAN_HOME")
local VAULT_FOLDER = OBSIDIAN_HOME .. "003_vault/"
local INBOX_FOLDER = OBSIDIAN_HOME .. "000_inbox/"
local JOURNAL_FOLDER = OBSIDIAN_HOME .. "001_journal/"


-- function list_files_in_directory(directory)
--   local handle = io.popen('ls "' .. directory .. '"')
--   local result = handle:read("*a")
--   handle:close()
--   local files = {}
--   for file in string.gmatch(result, "[^\r\n]+") do
--     table.insert(files, file)
--   end
--   return files
-- end
-- 
-- function deque_inbox()
--     local files = list_files_in_directory(INBOX_FOLDER)
--     if files and #files > 0 then
--         vim.cmd("edit " .. INBOX_FOLDER .. files[1])
--     else
--         print("Your inbox is empty")
--     end
-- end

function daily_note() vim.cmd("edit " .. JOURNAL_FOLDER .. os.date("%Y-%m-%d") .. '.md') end
function next_daily_note() vim.cmd("edit " .. JOURNAL_FOLDER .. os.date("%Y-%m-%d", (os.time() + 86400)) .. '.md') end
function previous_daily_note() vim.cmd("edit " .. JOURNAL_FOLDER .. os.date("%Y-%m-%d", (os.time() - 86400)) .. '.md') end

function sort_by_width(opts)
  local command = string.format(':%d,%d! awk \'{ print length(), $0 | "sort -n | cut -d\\\\  -f2-" }\'', opts.line1, opts.line2)
  vim.cmd(command)
end

function new_note()
    -- vim.cmd("edit " .. INBOX_FOLDER .. os.date("%Y-%m-%dT%H:%M:%S%z") .. '.md')
    vim.cmd("edit " .. INBOX_FOLDER .. " | normal a")
end

