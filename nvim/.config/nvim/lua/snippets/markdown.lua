local ls = require("luasnip")
local s  = ls.snippet
local i  = ls.insert_node
local f  = ls.function_node
local t  = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local function make_md_fence(lang)
	return s(
		lang, -- trigger
		fmt(
			string.format(
				[[
```%s
{}
```]],
				lang
			),
			{ i(1, "code") }
		),
		{ delimiters = "{}", description = "Markdown " .. lang .. " code fence" }
	)
end

local function hdr()
  return s({ trig = "hdr", name = "Header 62" }, {
    t("# "),
    i(1, "[comment]"),
    f(function (args)
        local comment = args[1][1] or ""
        if comment:match("^%s*$") then
          comment = "[comment]"
        end
        local total = 62
        -- "# " (2) + comment + " " (1)
        local prefix_width = vim.fn.strdisplaywidth("# " .. comment .. " ")
        local dashes = math.max(total - prefix_width, 0)
        return " " .. string.rep("-", dashes)
    end, { 1 }),
  })
end

ls.add_snippets("markdown", {
	make_md_fence("py"),
	make_md_fence("sh"),
	make_md_fence("json"),
  hdr(),
})
