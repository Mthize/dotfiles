return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	opts = {
		focus = true,
		use_diagnostic_signs = true, -- use Neovim’s built-in LSP signs
	},
	cmd = "Trouble",
	keys = {
		{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
		{
			"<leader>xd",
			"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Open trouble document diagnostics",
		},
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
	},

	config = function(_, opts)
		local trouble = require("trouble")
		trouble.setup(opts)

		-- 🔁 Auto-refresh Trouble diagnostics when open
		vim.api.nvim_create_autocmd("DiagnosticChanged", {
			callback = function()
				if trouble.is_open() then
					trouble.refresh()
				end
			end,
		})

		-- 💡 Optional: automatically open Trouble when diagnostics appear
		-- Uncomment below if you want it to pop up when new issues are detected
		-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
		--   callback = function()
		--     local diagnostics = vim.diagnostic.get(0)
		--     if #diagnostics > 0 and not trouble.is_open() then
		--       vim.cmd("Trouble diagnostics open")
		--     end
		--   end,
		-- })
	end,
}
