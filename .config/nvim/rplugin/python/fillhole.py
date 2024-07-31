# NOTE: Idea stolen from the great @VictorTaelin
# Implementation my own

import re
import os
import openai
import pynvim


HOLE_FILLER_SYSTEM_PROMPT = """
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
"""


@pynvim.plugin
class Filler(object):
    def __init__(self, vim):
        self.vim = vim
        self.client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        self.model = "gpt-3.5-turbo"
        self.system_prompt = HOLE_FILLER_SYSTEM_PROMPT
    @pynvim.command('Fill', range='', nargs='*', sync=True)
    def command_handler(self, args, range):
        buf = self.vim.api.get_current_buf()
        buf_lines = self.vim.api.buf_get_lines(buf,0,-1,False)
        buf_text = '\n'.join(buf_lines)

        response = self.client.chat.completions.create(
            model=self.model,
            messages=[
                {"role": "system", "content": self.system_prompt},
                {"role": "user", "content": f"<QUERY>\n{buf_text}\n</QUERY>"}],
        ).choices[0].message.content

        response_result = re.findall(r'<COMPLETION>(.*?)</COMPLETION>',response,re.DOTALL) 
        assert len(response_result), "<COMPLETION> tag not found on result. There must have been a prompt error."

        completion = response_result[0]
        buf_text_replaced = buf_text.replace("{{FILL HERE}}", completion)
        buf_text_replaced_lines = buf_text_replaced.split('\n')
        self.vim.api.buf_set_lines(buf,0,-1,False,buf_text_replaced_lines)
