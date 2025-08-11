vim.api.nvim_create_user_command("RunYTMDLink", function()
	-- Get the current line number and content
	local line = vim.api.nvim_get_current_line()
	-- Extract the URL from the line
	local url = line:match("https?://%S+")
	if url then
		-- Run the external command and capture the output
		local output = vim.fn.system('ytmdlink "' .. url .. '"')
		-- Replace newlines with spaces to keep it on one line
		output = output:gsub("\n", " ")
		-- Replace the URL in the line with the command output
		local new_line = line:gsub(vim.pesc(url), output)
		-- Set the new line content
		vim.api.nvim_set_current_line(new_line)
	else
		print("No URL found in the current line.")
	end
end, { nargs = 0 })

vim.api.nvim_create_user_command("CopyFilePath", function()
	local file_path = vim.api.nvim_buf_get_name(0)
	vim.fn.setreg("+", file_path)
	print("File path copied to clipboard: " .. file_path)
end, { nargs = 0 })
