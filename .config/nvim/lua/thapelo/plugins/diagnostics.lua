-- ~/.config/nvim/lua/config/diagnostics.lua
---@type LazyPluginSpec
return {
	-- Configure diagnostics (LSP loaded in lspconfig.lua)
	"neovim/nvim-lspconfig",
	lazy = true,
	config = function()
		vim.diagnostic.config({
			virtual_text = true,
			virtual_lines = false,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end,
}
