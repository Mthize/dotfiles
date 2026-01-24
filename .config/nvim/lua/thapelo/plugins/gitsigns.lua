return {
	-- Dependency for a better git experience, although not strictly required by gitsigns.
	"tpope/vim-fugitive",

	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy", -- Lazily load gitsigns to improve startup time.
		opts = {
			-- 5. Easily customizable symbols for git signs.
			signs = {
				add = { text = "▍" }, -- vertical bar
				change = { text = "▌" }, -- thicker vertical bar
				delete = { text = "契" }, -- fancy cross / delete symbol
				topdelete = { text = "契" },
				changedelete = { text = "▎" }, -- smaller vertical bar
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`

			-- 7. Debounce settings for performance on large files.
			update_debounce = 200,

			-- 6. Enable current line blame with customizable options.
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 500,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> — <summary>",

			-- Attach keymaps when gitsigns is attached to a buffer.
			on_attach = function(bufnr)
				-- 3. Use a single local reference for gitsigns functions.
				local gs = package.loaded.gitsigns

				-- 4. Helper function for setting keymaps with proper options.
				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, noremap = true, silent = true, desc = desc })
				end

				-- Hunk Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, "Next Git Hunk")

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, "Previous Git Hunk")

				-- 7. Modern features: Staging, Resetting, and other actions
				-- Actions
				map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage Hunk (Visual)")
				map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset Hunk (Visual)")

				map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
				map("n", "<leader>gU", gs.undo_stage_hunk, "Undo Last Stage")

				map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame Line")
				map("n", "<leader>gt", gs.toggle_current_line_blame, "Toggle Line Blame")
				map("n", "<leader>gd", gs.diffthis, "Diff This File")
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end, "Diff Against Index")

				-- Text object for hunks
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk Text Object")
			end,
		},
	},
}
