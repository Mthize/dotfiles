return {
	"craftzdog/solarized-osaka.nvim",
	lazy = false, -- Load the colorscheme at startup
	priority = 1000, -- Ensure it loads before other plugins
	opts = {
		transparent = true, -- Enable transparent background
		terminal_colors = true, -- Set terminal colors
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = { italic = false },
			variables = {},
			sidebars = "dark", -- Set dark backgrounds for sidebars
			floats = "dark", -- Set dark backgrounds for floating windows
		},
		sidebars = { "qf", "help" }, -- Specify which sidebars to apply the dark style to
		day_brightness = 0.3,
		hide_inactive_statusline = false,
		dim_inactive = false,
		lualine_bold = false,

		on_colors = function(colors)
			-- You can add custom color overrides here if needed
		end,

		-- ADDED THIS SECTION TO FIX DASHBOARD COLORS
		on_highlights = function(hl, c)
			-- This assumes a dashboard plugin like alpha-nvim or dashboard-nvim.
			-- Highlight for the main text like "Find files"
			hl.DashboardLabel = { fg = c.yellow, bold = true }
			-- Highlight for the shortcut keys like "f"
			hl.DashboardShortCut = { fg = c.orange }

			-- Fallbacks for alpha-nvim
			hl.AlphaButtons = { fg = c.yellow, bold = true }
			hl.AlphaShortcut = { fg = c.orange }
		end,
	},
	config = function(_, opts)
		require("solarized-osaka").setup(opts)
		-- Load the colorscheme
		vim.cmd.colorscheme("solarized-osaka")
	end,
}
