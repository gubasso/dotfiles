local M = {}

function M.strip_outer_quotes(s)
	s = (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
	local first, last = s:sub(1, 1), s:sub(-1)
	if (first == '"' and last == '"') or (first == "'" and last == "'") then
		s = s:sub(2, -2)
	end
	return s
end

function M.slugify(title)
	local slug = (title or "")
		:gsub("^%s+", "")
		:gsub("%s+$", "")
		:lower()
		:gsub("[_%s]+", "-")
		:gsub("[^%w%-]+", "-")
		:gsub("%-+", "-")
		:gsub("^%-+", "")
		:gsub("%-+$", "")

	if slug == "" then
		slug = "untitled"
	end
	return slug
end

return M
