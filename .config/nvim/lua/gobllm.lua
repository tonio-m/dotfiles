-- NOTE: Idea stolen from the great @VictorTaelin and melbaldove/llm.nvim
-- this is my cute rewrite
local M = {}
local vim = vim or {}
local curl = require('plenary.curl')
local INTERNAL_FILL_MARKER = "{{" .. "FILL HERE" .. "}}"

local CHAT_CODING_ASSISTANT_SYSTEM_PROMPT = [[
You are an AI programming assistant. Follow the user's requirements carefully & to the letter. 
You are an expert on software development. Keep your answers short and impersonal. 
First think step-by-step. Then output the code in a single code block. Minimize any other prose. 
Use Markdown formatting in your answers. 
Make sure to include the programming language name at the start of the Markdown code blocks. 
Avoid wrapping the whole response in triple backticks. The user works in an IDE called Neovim. 
You can only give one reply for each conversation turn.
]]
local CHAT_GENERAL_HELPER_SYSTEM_PROMPT = [[
You are a helpful, knowledgeable assistant focused on supporting users with any task or question. 

Key guidelines:
- Provide clear, direct answers without unnecessary caveats
- Break down complex problems step by step
- Be concise for simple questions, thorough for complex ones
- Use appropriate formatting (bullet points, numbered lists, etc.) for clarity 
- Include relevant examples when helpful
- State limitations of knowledge when applicable
- Ask clarifying questions only when truly needed
- Maintain a warm, professional tone without being overly casual

When handling requests:
1. First understand the core need/question
2. Consider the most effective way to structure the response
3. Provide the answer/solution
4. Offer to elaborate only if additional detail would be genuinely helpful

Your responses should be practical and actionable while avoiding unnecessary length or repetition.
]]
local FILL_SYSTEM_PROMPT = [[
You're a code completion assistant. 
You're an expert in generating blocks of code.
You are provided with a file containing holes, formatted as ']] .. INTERNAL_FILL_MARKER .. [['. 
Write ONLY the needed text to replace ]] .. INTERNAL_FILL_MARKER ..[[ with the correct completion, 
including correct spacing and indentation. Include the answer inside a <COMPLETION></COMPLETION> tag.
All completions MUST be truthful, accurate, well-written and correct. Think step by step.
]]
local REPLACE_SYSTEM_PROMPT = [[
You're a specialized code completion assistant with expertise in all programming languages. 
When given a code block and modification instructions:
1. Output ONLY the modified code with proper indentation and spacing
2. Do not include backticks, comments about the changes, or any non-code text
3. Maintain the original code's language and style conventions
4. Preserve any language-specific formatting requirements
5. Handle any programming language without changing the input language
6. Do not add explanatory text before or after the code
7. Think through the changes step by step before outputting
8. Ensure the output is complete, accurate, and production-ready
]]

local log_level = {
    DEBUG = "DEBUG",
    INFO = "INFO",
    WARN = "WARN",
    ERROR = "ERROR"
}
local log_file = '/tmp/gobllm.log'

function log_message(message, level)
    level = level or log_level.INFO
    local log_entry = string.format("%s [%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), level, message)
    local file = assert(vim.loop.fs_open(log_file, "a", 438)) -- 438 is octal for 0666 permissions
    vim.loop.fs_write(file, log_entry, -1)
    vim.loop.fs_close(file)
end

function split_into_lines(str)
    local lines = {}
    for line in str:gmatch("([^\r\n]*)\r?\n?") do
        table.insert(lines, line)
    end
    return lines
end

function read_file(filepath)
    local current_dir = io.popen("pwd"):read("*l")
    local full_path = current_dir .. "/" .. filepath
    local file = io.open(full_path, "r")
    log_message("reading file... " .. full_path)
    if not file then
        error("File not found: " .. full_path)
    end
    local content = file:read("*all")
    file:close()
    log_message("File read successfully.")
    return content
end

function replace_file_links(text)
    log_message("Replacing file links in user messages...")

    local result = "\n" .. text
    for match in result:gmatch("\n!<[^>]+>") do

        local filepath = match:sub(4, -2)
        local file_contents = read_file(filepath)
        log_message("file_contents: " .. string.gsub(file_contents, "\n", "\\n"):sub(1, 50), log_level.DEBUG)

        if file_contents == nil then
            log_message("Failed to replace file link, file not accessible: " .. filepath, log_level.WARN)
        end

        local escaped_match = match:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
        result = result:gsub(escaped_match, "\n```".. filepath .."\n".. file_contents .. "```")
        log_message("doing replacement of file links... ", log_level.DEBUG)
        -- log_message("doing replacement of file links... result = " .. result, log_level.DEBUG)
    end
    return result
end

function parse_chat(text)
    local messages= {}
    local content = ""
    local role = nil

    local lines = split_into_lines(text)
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

function completion_request_openai(messages,system_prompt,config)
    table.insert(messages, 1, {
        role = "system",
        content = system_prompt
    })
    local response = curl.post(config.url, {
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. config.api_key,
        },
        body = vim.fn.json_encode({
            model = config.model,
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

function completion_request_anthropic(messages,system_prompt,config)
    local response = curl.post(config.url, {
        headers = {
            ["Content-Type"] = "application/json",
            ["anthropic-version"] = "2023-06-01",
            ["x-api-key"] = config.api_key,
        },
        body = vim.fn.json_encode({
            system = system_prompt,
            messages = messages,
            model = config.model,
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

function completion_request(messages, system_prompt)
    if M.config.provider == "openai" then
        return completion_request_openai(messages, system_prompt,M.config)
    elseif M.config.provider == "anthropic" then
        return completion_request_anthropic(messages, system_prompt,M.config)
    else
        error("Invalid provider specified. Must be 'openai' or 'anthropic'")
    end
end

function M.fill()
    local current_buffer = vim.fn.bufnr('%')
    local buffer_str = table.concat(vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false),"\n")
    buffer_str = buffer_str:gsub(M.config.fill_marker, INTERNAL_FILL_MARKER)
    local messages = {
        {role = "user", content = buffer_str}
    }
    local completion = completion_request(messages,FILL_SYSTEM_PROMPT)
    completion = completion:gsub("<COMPLETION>","")
    completion = completion:gsub("</COMPLETION>","")
    buffer_str = buffer_str:gsub(INTERNAL_FILL_MARKER, completion)
    vim.api.nvim_buf_set_lines(current_buffer, 0, -1, false, split_into_lines(buffer_str))
end

function M.replace(opts)
    log_message("Executing replace function...")
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
    log_message("Values passed: " .. code_block .. ", " .. task)
    local messages = {
        {role = "user", content = "```\n" .. code_block .. "\n```\n\n" .. task}
    }
   local completion = completion_request(messages,REPLACE_SYSTEM_PROMPT)

    -- set the lines to be those of completion
    local current_buffer = vim.fn.bufnr('%')
    vim.api.nvim_buf_set_lines(current_buffer, start_line - 1, end_line, false, split_into_lines(completion))
    log_message("Call of complete_replace sucessful.")
end

function chat_factory(system_prompt)
    return function()
        log_message("Preparing to start chat...")
        local current_buffer = vim.fn.bufnr('%')
        local buffer_str = table.concat(vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false),"\n")
        log_message("Parsing chat buffer...")
        local messages = parse_chat(buffer_str)
        for i, message in ipairs(messages) do
            if message.role == "user" then
                local expanded_text = replace_file_links(messages[i].content)
                messages[i].content = expanded_text
            end
        end
        log_message("Requesting answer from LLM...")
        log_message("messages: " .. vim.inspect(messages), log_level.DEBUG)
        local answer = completion_request(messages,system_prompt)
        local line_count = vim.api.nvim_buf_line_count(current_buffer)
        vim.api.nvim_buf_set_lines(current_buffer, line_count, line_count, false, split_into_lines("### A:\n" .. answer .. "\n### Q:"))
        log_message("Chat Completion successful.")
    end
end

M.chat_coding_assistant = chat_factory(CHAT_CODING_ASSISTANT_SYSTEM_PROMPT)
M.chat_general_helper = chat_factory(CHAT_GENERAL_HELPER_SYSTEM_PROMPT)

function M.open_chat()
  vim.cmd("enew")
  vim.cmd("set filetype=markdown")
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { "### Q:" })
end

function M.setup(opts)
    -- Default configuration
    M.config = {
        -- Choose your AI provider and model
        provider = "anthropic", -- or "openai"
        -- API configuration
        api_key_name = "ANTHROPIC_API_KEY",
        model = "claude-3-5-sonnet-latest",
        -- model = "claude-3-haiku-20240307",
        url = "https://api.anthropic.com/v1/messages",
        fill_marker = "<" .. ">",
        -- OpenAI defaults (uncomment to use)
        -- provider = "openai",
        -- api_key_name = "OPENAI_API_KEY",
        -- model = "gpt-4",
        -- url = "https://api.openai.com/v1/chat/completions",
    }

    -- Override defaults with user options
    if opts then
        for key, value in pairs(opts) do
            M.config[key] = value
        end
    end

    -- Get API key from environment variable
    M.config.api_key = os.getenv(M.config.api_key_name)
    -- Validate API key
    if not M.config.api_key then
        error(string.format("Missing API key: Please set the %s environment variable", M.config.api_key_name))
    end
end

return M

