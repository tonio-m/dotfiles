-- NOTE: Idea stolen from the great @VictorTaelin and melbaldove/llm.nvim
-- this is my cute rewrite
local M = {}
local vim = vim or {}
local curl = require('plenary.curl')
local CHAT_SYSTEM_PROMPT = [[
You are an AI programming assistant. Follow the user's requirements carefully & to the letter. 
You are an expert on software development. Keep your answers short and impersonal. 
First think step-by-step. Then output the code in a single code block. Minimize any other prose. 
Use Markdown formatting in your answers. 
Make sure to include the programming language name at the start of the Markdown code blocks. 
Avoid wrapping the whole response in triple backticks. The user works in an IDE called Neovim. 
You can only give one reply for each conversation turn.
]]
local USER_COMPLETION_MARKER = "<"..">"
local INTERNAL_COMPLETION_MARKER = "{{" .. "FILL HERE" .. "}}"
local COMPLETE_SYSTEM_PROMPT = [[
You're a code completion assistant. 
You're an expert in generating blocks of code.
You are provided with a file containing holes, formatted as ']] .. INTERNAL_COMPLETION_MARKER .. [['. 
Write ONLY the needed text to replace ]] .. INTERNAL_COMPLETION_MARKER ..[[ with the correct completion, 
including correct spacing and indentation. Include the answer inside a <COMPLETION></COMPLETION> tag.
All completions MUST be truthful, accurate, well-written and correct. Think step by step.
]]
local COMPLETE_REPLACE_SYSTEM_PROMPT = [[
You're a code completion assistant. 
You're an expert in generating blocks of code.
You are provided with a block of code inside backticks and a specific task'. 
Rewrite the block according to the instructions of the task.
Write ONLY the needed code to replace the block with the correct alternative, 
including correct spacing and indentation. 
All completions MUST be truthful, accurate, well-written and correct. Think step by step.
]]

local log_level = {
    DEBUG = "DEBUG",
    INFO = "INFO",
    WARN = "WARN",
    ERROR = "ERROR"
}
local log_file = vim.fn.stdpath('data') .. '/gobllm.log'

function M.open_chat_buffer()
  vim.cmd("enew")
  vim.cmd("set filetype=markdown")
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { "### Q:" })
end

function M.log_message(message, level)
    level = level or log_level.INFO
    local log_entry = string.format("%s [%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), level, message)
    local file = assert(vim.loop.fs_open(log_file, "a", 438)) -- 438 is octal for 0666 permissions
    vim.loop.fs_write(file, log_entry, -1)
    vim.loop.fs_close(file)
end

function M.split_into_lines(str)
    local lines = {}
    for line in str:gmatch("([^\r\n]*)\r?\n?") do
        table.insert(lines, line)
    end
    return lines
end

function M.read_file(filepath)
    local current_dir = io.popen("pwd"):read("*l")
    local full_path = current_dir .. "/" .. filepath
    local file = io.open(full_path, "r")
    M.log_message("reading file... " .. full_path)
    if not file then
        error("File not found: " .. full_path)
    end
    local content = file:read("*all")
    file:close()
    M.log_message("File read successfully.")
    return content
end

function M.replace_file_links(text)
    M.log_message("Replacing file links in user messages...")

    local result = "\n" .. text
    for match in result:gmatch("\n!<[^>]+>") do

        local filepath = match:sub(4, -2)
        local file_contents = M.read_file(filepath)
        M.log_message("file_contents: " .. string.gsub(file_contents, "\n", "\\n"):sub(1, 50), log_level.DEBUG)

        if file_contents == nil then
            M.log_message("Failed to replace file link, file not accessible: " .. filepath, log_level.WARN)
        end

        local escaped_match = match:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
        result = result:gsub(escaped_match, "\n```".. filepath .."\n".. file_contents .. "```")
        M.log_message("doing replacement of file links... ", log_level.DEBUG)
        -- M.log_message("doing replacement of file links... result = " .. result, log_level.DEBUG)
    end
    return result
end

function M.parse_chat(text)
    local messages= {}
    local content = ""
    local role = nil
    local lines = M.split_into_lines(text)
    for i, line in ipairs(lines) do
        if (line:match("^### Q:%s*") or  line:match("^### A:%s*") or i  == #lines) and i ~= 1 then
            table.insert(messages,{role = role, content = content})
            content = ""
        end
        if line:match("^### Q:%s*")  then
            role = "user"
        elseif line:match("^### A:%s*") then
            role = "assistant"
        else
            content = content .. line .. "\n"
        end
    end
    return messages
end

-- TODO: make this (anthropic/openai) switchable like it was before
function M.completion_request_openai(messages,system_prompt)
    table.insert(messages, 1, {
        role = "system",
        content = system_prompt
    })
    local response = curl.post(M.config.url, {
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. M.config.api_key,
        },
        body = vim.fn.json_encode({
            model = M.config.model,
            messages = messages,
        }),
        timeout = 60000
    })

    if response.status ~= 200 then
        vim.notify("HTTP ERROR:" .. response.status)
        vim.notify(response.body)
        error("Failed to get a valid response from the API")
    end
    local answer = vim.fn.json_decode(response.body).choices[1].message.content
    return answer
end

function M.completion_request_anthropic(messages,system_prompt)
    local response = curl.post(M.config.url, {
        headers = {
            ["Content-Type"] = "application/json",
            ["anthropic-version"] = "2023-06-01",
            ["x-api-key"] = M.config.api_key,
        },
        body = vim.fn.json_encode({
            system = system_prompt,
            messages = messages,
            model = M.config.model,
            max_tokens = 4000,
        }),
        timeout = 60000
    })
    if response.status ~= 200 then
        vim.notify("HTTP ERROR:" .. response.status)
        vim.notify(response.body)
        error("Failed to get a valid response from the API")
    end
    local answer = vim.fn.json_decode(response.body).content[1].text
    return answer
end

function M.chat()
    M.log_message("Preparing to start chat...")
    local current_buffer = vim.fn.bufnr('%')
    local buffer_str = table.concat(vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false),"\n")

    M.log_message("Parsing chat buffer...")
    local messages = M.parse_chat(buffer_str)

    for i, message in ipairs(messages) do
        if message.role == "user" then
            local expanded_text = M.replace_file_links(messages[i].content)
            messages[i].content = expanded_text
        end
    end

    M.log_message("Requesting answer from LLM...")
    M.log_message("messages: " .. vim.inspect(messages), log_level.DEBUG)
    local answer = M.completion_request_anthropic(messages,CHAT_SYSTEM_PROMPT)
    local line_count = vim.api.nvim_buf_line_count(current_buffer)
    vim.api.nvim_buf_set_lines(current_buffer, line_count, line_count, false, M.split_into_lines("### A:\n" .. answer .. "\n### Q:"))
    M.log_message("Chat Completion successful.")
end

function M.complete()
    local current_buffer = vim.fn.bufnr('%')
    local buffer_str = table.concat(vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false),"\n")
    buffer_str = buffer_str:gsub(USER_COMPLETION_MARKER, INTERNAL_COMPLETION_MARKER)
    local messages = {
        {role = "user", content = buffer_str}
    }
    local completion = M.completion_request_anthropic(messages,COMPLETE_SYSTEM_PROMPT)
    completion = completion:gsub("<COMPLETION>","")
    completion = completion:gsub("</COMPLETION>","")
    buffer_str = buffer_str:gsub(INTERNAL_COMPLETION_MARKER, completion)
    vim.api.nvim_buf_set_lines(current_buffer, 0, -1, false, M.split_into_lines(buffer_str))
end

function M.replace(opts)
    M.log_message("Executing replace function...")
    local task = opts.args
    local end_line = opts.line2
    local start_line = opts.line1
    -- Iterate over the selected range
    local lines = {}
    for line = start_line, end_line do
        local text = vim.fn.getline(line)
        table.insert(lines,text)
    end
    local code_block = table.concat(lines,"\n")
    M.log_message("Values passed: " .. code_block .. ", " .. task)

    local messages = {
        {role = "user", content = "```\n" .. code_block .. "\n```\n\n" .. task}
    }
    local completion = M.completion_request_anthropic(messages,COMPLETE_REPLACE_SYSTEM_PROMPT)
    completion = completion:gsub("```\n","")
    completion = completion:gsub("\n```","")
    -- set the lines to be those of completion
    local current_buffer = vim.fn.bufnr('%')
    vim.api.nvim_buf_set_lines(current_buffer, start_line - 1, end_line, false, M.split_into_lines(completion))
    M.log_message("Call of complete_replace sucessful.")
end

function M.setup(opts)
	M.config= {
		-- model = "gpt-4o",
		-- api_key_name = "OPENAI_API_KEY",
		-- url = "https://api.openai.com/v1/chat/completions",
		api_key_name = "ANTHROPIC_API_KEY",
		model = "claude-3-5-sonnet-20241022",
        url = "https://api.anthropic.com/v1/messages",
	}
    for key, value in pairs(opts) do
      M.config[key] = value
    end
    M.config.api_key = os.getenv(M.config.api_key_name)
end

return M

