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

-- Pads the current line (from cursor position) with '-' up to 62 columns.
local function dash_to_62()
  return s(
    { trig = "d62", name = "Fill line to 62 with dashes", dscr = "Pad with '-' until the line has 62 columns", wordTrig = false },
    f(function(_)
      local col = vim.fn.col(".")
      local total  = 62
      local n      = math.max(total - col + 1, 0)
      return string.rep("-", n)
    end)
  )
end

ls.add_snippets("markdown", {
	make_md_fence("py"),
	make_md_fence("sh"),
	make_md_fence("json"),
  hdr(),
  dash_to_62(),
})
