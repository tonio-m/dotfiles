local function get_bracketed_path()
    local line = vim.fn.getline('.')
    local col = vim.fn.col('.')
    local match_start, match_end = line:find('%[%[.-%]%]')
    if match_start and match_end and col >= match_start and col <= match_end then
        -- Extract content between [[]]
        local content = line:sub(match_start + 2, match_end - 2)
        -- Strip alias part (after |) if it exists
        local path = content:match("^(.-)%s*|") or content
        return path:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
    end
    -- Return nil if no brackets found
    return nil
end

-- TODO: make this apply only to markdown links
-- Custom gf behavior
vim.keymap.set('n', 'gf', function()
    local bracketed_path = get_bracketed_path()
    if bracketed_path then
        vim.cmd('edit ' .. bracketed_path)
    else
        -- Default gf behavior
        vim.cmd('normal! gf')
    end
end)

-- Custom ctrl+click behavior (for GUI)
vim.keymap.set('n', '<C-LeftMouse>', function()
    local bracketed_path = get_bracketed_path()
    if bracketed_path then
        vim.cmd('edit ' .. bracketed_path)
    else
        -- Default ctrl+click behavior
        vim.cmd('normal! <C-LeftMouse>')
    end
end)

-- Custom CTRL-W f behavior (open in split)
vim.keymap.set('n', '<C-w>f', function()
    local bracketed_path = get_bracketed_path()
    if bracketed_path then
        vim.cmd('split ' .. bracketed_path)
    else
        -- Default CTRL-W f behavior
        vim.cmd('normal! <C-w>f')
    end
end)

-- Custom CTRL-W gf behavior (open in new tab)
vim.keymap.set('n', '<C-w>gf', function()
    local bracketed_path = get_bracketed_path()
    if bracketed_path then
        vim.cmd('tabe ' .. bracketed_path)
    else
        -- Default CTRL-W gf behavior
        vim.cmd('normal! <C-w>gf')
    end
end)
