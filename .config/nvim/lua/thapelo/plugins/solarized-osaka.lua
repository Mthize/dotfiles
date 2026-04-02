return {
	"craftzdog/solarized-osaka.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		terminal_colors = true,
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = { italic = false },
			variables = {},
			sidebars = "dark",
			floats = "dark",
		},
		sidebars = { "qf", "help" },
		day_brightness = 0.3,
		hide_inactive_statusline = false,
		dim_inactive = false,
		lualine_bold = false,

		on_highlights = function(hl, c)
			-- Map AlphaButtons to Solarized Green (#859900)
			hl.AlphaButtons = { fg = c.green, bold = true }
			-- Map AlphaShortcut to Solarized Cyan (#2aa198)
			hl.AlphaShortcut = { fg = c.cyan }

			-- Ensure Dashboard highlights match if used
			hl.DashboardLabel = { fg = c.green, bold = true }
			hl.DashboardShortCut = { fg = c.cyan }
		end,
	},
	config = function(_, opts)
		local solarized = require("solarized-osaka")
		solarized.setup(opts)
		vim.cmd.colorscheme("solarized-osaka")

		-- Persistence: Reapply highlights on ColorScheme change
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "solarized-osaka",
			callback = function()
				local c = require("solarized-osaka.colors").setup()
				vim.api.nvim_set_hl(0, "AlphaButtons", { fg = c.green, bold = true })
				vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = c.cyan })
			end,
		})
	end,
}