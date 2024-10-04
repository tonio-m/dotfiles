-- NOTE: Idea stolen from the great @VictorTaelin and melbaldove/llm.nvim
-- t his is my cute rewrite
local M = {}
local vim = vim or {}
local curl = require('plenary.curl')
local CHAT_SYSTEM_PROMPT = [[
You are an AI programming assistant. Follow the user's requirements carefully & to the letter. You are an expert on software development. Keep your answers short and impersonal. First think step-by-step - describe your plan for what to build. Then output the code in a single code block. Minimize any other prose. Use Markdown formatting in your answers. Make sure to include the programming language name at the start of the Markdown code blocks. Avoid wrapping the whole response in triple backticks. The user works in an IDE called Neovim. You can only give one reply for each conversation turn.
]]
local USER_COMPLETION_MARKER = "<"..">"
local INTERNAL_COMPLETION_MARKER = "{{" .. "FILL HERE" .. "}}"
local DEFAULT_SYSTEM_PROMPT = [[
You're a code completion assistant. 
You're an expert in generating blocks of code.
You are provided with a file containing holes, formatted as ']] .. INTERNAL_COMPLETION_MARKER .. [['. 
Write ONLY the needed text to replace ]] .. INTERNAL_COMPLETION_MARKER ..[[ with the correct completion, including correct spacing and indentation. 
Include the answer inside a <COMPLETION></COMPLETION> tag.
All completions MUST be truthful, accurate, well-written and correct.
Think step by step.
]]

function M.split_into_lines(str)
    local lines = {}
    for line in str:gmatch("([^\r\n]*)\r?\n?") do
        table.insert(lines, line)
    end
    return lines
end

function M.complete()
    local current_buffer = vim.fn.bufnr('%')
    local buffer_str = table.concat(vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false),"\n")
    buffer_str = buffer_str:gsub(USER_COMPLETION_MARKER, INTERNAL_COMPLETION_MARKER)
    local messages = {
        {role = "system", content = M.config.system_prompt},
        {role = "user", content = buffer_str}
    }
    local completion = M.completion_request(messages)
    completion = completion:gsub("<COMPLETION>","")
    completion = completion:gsub("</COMPLETION>","")
    buffer_str = buffer_str:gsub(INTERNAL_COMPLETION_MARKER, completion)
    vim.api.nvim_buf_set_lines(current_buffer, 0, -1, false, M.split_into_lines(buffer_str))
end

function M.chat()
    local current_buffer = vim.fn.bufnr('%')
    local buffer_str = table.concat(vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false),"\n")

    local messages = M.parse_chat(buffer_str)
    table.insert(messages,1,{role = "system", content = CHAT_SYSTEM_PROMPT})

    local answer = M.completion_request(messages)
    local line_count = vim.api.nvim_buf_line_count(current_buffer)
    vim.api.nvim_buf_set_lines(current_buffer, line_count, line_count, false, M.split_into_lines("### A:\n" .. answer .. "\n### Q:"))
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

function M.completion_request(messages)
    local response = curl.post(M.config.url, {
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. M.config.api_key,
        },
        body = vim.fn.json_encode({
            model = M.config.model,
            messages = messages,
        }),
        timeout = 30000
    })
    if response.status ~= 200 then
        vim.notify("HTTP ERROR:" .. response.status)
        vim.notify(response.body)
        error("Failed to get a valid response from the API")
    end
    local answer = vim.fn.json_decode(response.body).choices[1].message.content
    return answer
end

function M.open_chat_buffer()
  vim.cmd("enew")
  vim.cmd("set wrap")
  vim.cmd("set filetype=markdown")
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { "### Q:" })
end

function M.setup(opts)
	M.config= {
		model = "gpt-4o",
		api_key_name = "OPENAI_API_KEY",
        system_prompt = DEFAULT_SYSTEM_PROMPT,
		url = "https://api.openai.com/v1/chat/completions",
	}
    for key, value in pairs(opts) do
      M.config[key] = value
    end
    M.config.api_key = os.getenv(M.config.api_key_name)
end

return M
