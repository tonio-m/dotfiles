-- NOTE: Idea stolen from the great @VictorTaelin and melbaldove/llm.nvim
-- this is my cute rewrite
local M = {}
local vim = vim or {}
local curl = require('plenary.curl')
local DEFAULT_SYSTEM_PROMPT = [[
You are a HOLE FILLER. 
You are provided with a file containing holes, formatted as '{{FILL HERE}}'. 
Your TASK is to complete with a string to replace this hole with, inside a <COMPLETION/> tag, including context-aware indentation.
All completions MUST be truthful, accurate, well-written and correct.

## EXAMPLE QUERY:

<QUERY>
function sum_evens(lim) {
  var sum = 0;
  for (var i = 0; i < lim; ++i) {
    {{FILL HERE}}
  }
  return sum;
}
</QUERY>

## CORRECT COMPLETION

<COMPLETION>if (i % 2 === 0) {
      sum += i;
    }</COMPLETION>

## EXAMPLE QUERY:

<QUERY>
def sum_list(lst):
  total = 0
  for x in lst:
  {{FILL HERE}}
  return total

print sum_list([1, 2, 3])
</QUERY>

## CORRECT COMPLETION:

<COMPLETION>  total += x</COMPLETION>

## EXAMPLE QUERY:

<QUERY>
// data Tree a = Node (Tree a) (Tree a) | Leaf a

// sum :: Tree Int -> Int
// sum (Node lft rgt) = sum lft + sum rgt
// sum (Leaf val)     = val

// convert to TypeScript:
{{FILL HERE}}
</QUERY>

## CORRECT COMPLETION:

<COMPLETION>type Tree<T>
  = {$:"Node", lft: Tree<T>, rgt: Tree<T>}
  | {$:"Leaf", val: T};

function sum(tree: Tree<number>): number {
  switch (tree.$) {
    case "Node":
      return sum(tree.lft) + sum(tree.rgt);
    case "Leaf":
      return tree.val;
  }
}</COMPLETION>

## EXAMPLE QUERY:

The 2nd {{FILL HERE}} is Saturn.

## CORRECT COMPLETION:

<COMPLETION>gas giant</COMPLETION>

## EXAMPLE QUERY:

function hypothenuse(a, b) {
  return Math.sqrt({{FILL HERE}}b ** 2);
}

## CORRECT COMPLETION:

<COMPLETION>a ** 2 + </COMPLETION>

## IMPORTANT:

- Answer ONLY with the <COMPLETION/> block. Do NOT include anything outside it.
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
    buffer_str = buffer_str:gsub("<>","{{FILL HERE}}")

    local response = curl.post(M.config.url, {
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. M.config.api_key,
        },
        body = vim.fn.json_encode({
            model = M.config.model,
            messages = {
                {role = "system", content = M.config.system_prompt},
                {role = "user", content = buffer_str}
            }
        }),
    })
    if response.status ~= 200 then
        vim.notify("HTTP ERROR:" .. response.status)
        return
    end

    local completion = vim.fn.json_decode(response.body).choices[1].message.content
    completion = completion:gsub("<COMPLETION>","")
    completion = completion:gsub("</COMPLETION>","")
    buffer_str = buffer_str:gsub("{{FILL HERE}}", completion)

    vim.api.nvim_buf_set_lines(current_buffer, 0, -1, false, M.split_into_lines(buffer_str))
end

function M.setup(opts)
	M.config= {
		url = "https://api.openai.com/v1/chat/completions",
		model = "gpt-4o",
		api_key_name = "OPENAI_API_KEY",
        system_prompt = DEFAULT_SYSTEM_PROMPT,
        completion_marker="<>",
	}
    for key, value in pairs(opts) do
      M.config[key] = value
    end
    M.config.api_key = os.getenv(M.config.api_key_name)
end

return M
