return {
	"hrsh7th/nvim-cmp",
	-- Load nvim-cmp on InsertEnter
	event = "InsertEnter",
	dependencies = {
		-- Sources
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"supermaven-inc/supermaven-nvim",

		-- Snippets
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",

		-- UI/Formatting
		"onsails/lspkind.nvim",
	},
	config = function()
		-- Set up local variables for plugins
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local sm_preview = require("supermaven-nvim.completion_preview")
		local sm_api = require("supermaven-nvim.api")

		-- Helper function for visual feedback on Supermaven actions
		local function flash_highlight(color)
			vim.api.nvim_set_hl(0, "CmpActionFlash", { fg = color, bold = true })
			vim.defer_fn(function()
				vim.api.nvim_set_hl(0, "CmpActionFlash", {})
			end, 120)
		end

		--
		-- ## Supermaven Configuration
		--
		require("supermaven-nvim").setup({
			-- The `keymaps` table is removed because we let nvim-cmp handle all keybindings.
			-- `disable_keymaps = true` is the default and not strictly needed, but it's good for clarity.
			disable_keymaps = true,

			-- Using a Lua table as a set for faster lookups.
			-- This is cleaner than the separate autocmd you had before.
			ignore_filetypes = { cpp = true, markdown = true, text = true },

			-- Using your preferred Catppuccin green for inline suggestions.
			color = {
				suggestion_color = "#a6e3a1",
			},
		})

		-- Load snippets from friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		--
		-- ## nvim-cmp Configuration
		--
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			-- Keybindings are the heart of the experience
			mapping = cmp.mapping.preset.insert({
				-- A smarter Tab key that prioritizes cmp, then snippets, then AI
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif sm_preview.has_suggestion() then
						sm_preview.accept_suggestion()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Your custom Supermaven keymaps with clean visual feedback
				["<M-l>"] = cmp.mapping(function()
					if sm_preview.has_suggestion() then
						flash_highlight("#a6e3a1") -- Green flash
						sm_preview.accept_suggestion()
					else
						-- Fallback to confirming the selected item from the cmp menu
						cmp.confirm({ select = true })
					end
				end),

				["<M-j>"] = cmp.mapping(function()
					if sm_preview.has_suggestion() then
						flash_highlight("#94e2d5") -- Teal flash
						sm_preview.accept_word()
					else
						cmp.select_next_item()
					end
				end),

				["<M-k>"] = cmp.mapping(function()
					if sm_preview.has_suggestion() then
						flash_highlight("#f38ba8") -- Red flash
						sm_preview.clear_suggestion()
					end
				end),

				-- Standard keybindings for navigation and control
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- False prevents confirming on new line
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-p>"] = cmp.mapping.select_prev_item(), -- <C-p> for 'previous' is safer than <C-k>
				["<C-n>"] = cmp.mapping.select_next_item(), -- <C-n> for 'next'
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
			}),

			-- Set source priority: AI > LSP > Snippets > Buffers > Paths
			sources = cmp.config.sources({
				{ name = "supermaven", priority = 100 },
				{ name = "nvim_lsp", priority = 90 },
				{ name = "luasnip", priority = 80 },
				{ name = "buffer", priority = 70 },
				{ name = "path", priority = 60 },
			}),

			-- UI and formatting with lspkind
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
					-- The `before` function is the correct way to add custom icons per source
					before = function(entry, vim_item)
						if entry.source.name == "supermaven" then
							vim_item.kind = "AI" -- Using a Nerd Font AI icon
						end
						return vim_item
					end,
					-- Your custom menu labels are preserved
					menu = {
						supermaven = "[AI]",
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
						path = "[Path]",
					},
				}),
			},

			-- Window appearance
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			-- Enable ghost text for a truly inline experience
			experimental = {
				ghost_text = true,
			},
		})

		-- The deprecated `autocomplete` option is replaced with this autocmd.
		-- It triggers completion automatically as you type.
		vim.api.nvim_create_autocmd("TextChangedI", {
			group = vim.api.nvim_create_augroup("CmpAutocomplete", { clear = true }),
			callback = function()
				require("cmp").complete()
			end,
		})

		--
		-- ## Commands and Utilities
		--
		-- Your excellent Supermaven toggle command, kept as is. ¿
		vim.api.nvim_create_user_command("SupermavenToggle", function()
			if sm_api.is_running() then
				sm_api.stop()
				vim.notify("Supermaven ¿ disabled", vim.log.levels.WARN, { title = "AI Completion" })
			else
				sm_api.start()
				vim.notify("Supermaven ¿ enabled", vim.log.levels.INFO, { title = "AI Completion" })
			end
		end, {})
	end,
}
