-- ~/.config/nvim/lua/config/diagnostics.lua
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" }, -- load on buffer open
	config = function()
		vim.diagnostic.config({
			virtual_text = true, -- show inline errors
			virtual_lines = true, -- show multi-line virtual diagnostics
			-- underline = true,       -- optional
			update_in_insert = false, -- don’t update diagnostics while typing
			severity_sort = true, -- sort by severity
		})
	end,
}
