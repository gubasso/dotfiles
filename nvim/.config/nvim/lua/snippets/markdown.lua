local ls         = require("luasnip")
local s, i, fmt  = ls.snippet, ls.insert_node, require("luasnip.extras.fmt").fmt

local function make_md_fence(lang)
  return s(
    lang,  -- trigger
    fmt(
      string.format([[
```%s
{}
```]], lang),
      { i(1, "code") }
    ),
    { delimiters = "{}", description = "Markdown " .. lang .. " code fence" }
  )
end

ls.add_snippets("markdown", {
  make_md_fence("py"),
  make_md_fence("sh"),
  make_md_fence("json"),
})
