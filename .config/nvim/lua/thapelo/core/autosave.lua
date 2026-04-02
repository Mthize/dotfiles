local M = {}

local function should_save(bufnr)
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return false
	end

	local buf = vim.bo[bufnr]
	if buf.buftype ~= "" then
		return false
	end

	if not buf.modifiable or buf.readonly or not buf.modified then
		return false
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	return name ~= ""
end

function M.setup()
	local group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

	vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
		group = group,
		desc = "Save automatically after typing or leaving insert mode",
		callback = function(args)
			local bufnr = args.buf
			if not should_save(bufnr) then
				return
			end

			vim.api.nvim_buf_call(bufnr, function()
				vim.cmd("silent! write")
			end)
		end,
	})
end

return M
