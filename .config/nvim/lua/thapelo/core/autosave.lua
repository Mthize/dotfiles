-- autosave.lua
local M = {}

function M.setup()
	vim.api.nvim_create_augroup("AutoSave", { clear = true })
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		pattern = "*",
		command = "silent! write",
	})
end

return M
