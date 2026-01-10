-- CopyFilePath: Copy current buffer's file path to clipboard
vim.api.nvim_create_user_command("CopyFilePath", function()
	local file_path = vim.api.nvim_buf_get_name(0)
	vim.fn.setreg("+", file_path)
	print("File path copied to clipboard: " .. file_path)
end, { nargs = 0 })
