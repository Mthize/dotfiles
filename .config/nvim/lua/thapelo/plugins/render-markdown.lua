return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- Make sure to use the dependencies that match your setup
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },

	-- lazy.nvim will automatically call the setup function with this opts table
	opts = {
		-- Catppuccin-friendly highlights
		highlights = {
			heading1 = "@markup.heading.1.markdown",
			heading2 = "@markup.heading.2.markdown",
			heading3 = "@markup.heading.3.markdown",
			heading4 = "@markup.heading.4.markdown",
			heading5 = "@markup.heading.5.markdown",
			heading6 = "@markup.heading.6.markdown",
			code = "ColorColumn",
			-- Custom highlights for new checkbox states
			RenderMarkdownTodo = { fg = "#f9e2af" }, -- Catppuccin Yellow
			RenderMarkdownInProgress = { fg = "#89b4fa" }, -- Catppuccin Blue
			RenderMarkdownCancelled = { fg = "#f38ba8" }, -- Catppuccin Red
		},

		-- Configuration for headings
		heading = {
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			width = { "full", "full", "block" },
			border = { true, true, false },
		},

		-- Configuration for code blocks
		code = {
			language_name = true,
			language_icon = true,
			background = true,
		},

		-- Configuration for bullet points
		bullet = {
			icons = { "●", "○", "◆", "◇" },
		},

		-- Configuration for block quotes
		quote = {
			icons = { "▎", "▎", "▎" },
		},

		-- NEW: Detailed configuration for checkboxes ✅
		checkbox = {
			-- Render the bullet point (`-` or `*`) before the checkbox
			bullet = false,
			-- Standard unchecked state: [ ]
			unchecked = {
				icon = "󰄱 ", -- nf-md-checkbox_blank_outline
				highlight = "RenderMarkdownUnchecked",
			},
			-- Standard checked state: [x]
			checked = {
				icon = "󰱒 ", -- nf-md-checkbox_marked
				highlight = "RenderMarkdownChecked",
			},
			-- Custom checkbox states for more detailed task lists
			custom = {
				-- To-Do / In-Progress: [-]
				todo = {
					raw = "[-]",
					rendered = "󰥔 ", -- nf-md-minus_box_outline
					highlight = "RenderMarkdownTodo",
				},
				-- In Progress / Half-Done: [/]
				inprogress = {
					raw = "[/]",
					rendered = "󰗡 ", -- nf-md-circle_half_full
					highlight = "RenderMarkdownInProgress",
				},
				-- Cancelled / Wontfix: [~]
				cancelled = {
					raw = "[~]",
					rendered = "󰜺 ", -- nf-md-close_box_outline
					highlight = "RenderMarkdownCancelled",
				},
			},
		},
	},

	-- Keymap to easily toggle rendering on and off
	keys = {
		{
			"<leader>mr", -- "m" for markdown, "r" for render
			function()
				require("render-markdown").toggle()
			end,
			desc = "Toggle Markdown Renderer",
		},
	},

	-- Automatically enable rendering for markdown files
	ft = { "markdown" },
	config = function(_, opts)
		require("render-markdown").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				require("render-markdown").enable()
			end,
		})
	end,
}
