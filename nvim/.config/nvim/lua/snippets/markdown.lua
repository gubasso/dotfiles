local ls         = require("luasnip")
local s, i, fmt  = ls.snippet, ls.insert_node, require("luasnip.extras.fmt").fmt

local code_block_snippet = s(
  "py",        -- trigger
  fmt([[
```py
{}
```
]],
  {
    i(1, "code"),  -- first tab-stop for your code
  },
  { delimiters = "{}", description = "Markdown Python code fence" }
))

ls.add_snippets("markdown", { code_block_snippet })
