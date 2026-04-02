return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"supermaven-inc/supermaven-nvim",
		{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local sm_preview = require("supermaven-nvim.completion_preview")
		local sm_api = require("supermaven-nvim.api")

		-- Helper: flash key press feedback
		local function flash_highlight(color)
			vim.api.nvim_set_hl(0, "CmpActionFlash", { fg = color, bold = true })
			vim.defer_fn(function()
				vim.api.nvim_set_hl(0, "CmpActionFlash", {})
			end, 120)
		end

		-- Supermaven setup
		require("supermaven-nvim").setup({
			disable_keymaps = true, -- let cmp handle keymaps
			ignore_filetypes = { cpp = true, markdown = true, text = true },
			color = { suggestion_color = "#a6e3a1" },
		})

		-- Load snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		-- nvim-cmp setup
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
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
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<M-l>"] = cmp.mapping(function()
					if sm_preview.has_suggestion() then
						flash_highlight("#a6e3a1")
						sm_preview.accept_suggestion()
					else
						cmp.confirm({ select = true })
					end
				end),

				["<M-j>"] = cmp.mapping(function()
					if sm_preview.has_suggestion() then
						flash_highlight("#94e2d5")
						sm_preview.accept_word()
					else
						cmp.select_next_item()
					end
				end),

				["<M-k>"] = cmp.mapping(function()
					if sm_preview.has_suggestion() then
						flash_highlight("#f38ba8")
						sm_preview.clear_suggestion()
					end
				end),

				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
			}),

			sources = cmp.config.sources({
				{ name = "supermaven", priority = 100 },
				{ name = "nvim_lsp", priority = 90 },
				{ name = "luasnip", priority = 80 },
				{
					name = "buffer",
					priority = 70,
					option = {
						-- Only index current buffer for performance
						get_bufnrs = function()
							return { vim.api.nvim_get_current_buf() }
						end,
					},
				},
				{ name = "path", priority = 60 },
			}),

			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
					before = function(entry, vim_item)
						if entry.source.name == "supermaven" then
							vim_item.kind = "AI"
						end
						return vim_item
					end,
					menu = {
						supermaven = "[AI]",
						nvim_lsp = "[LSP]",
						luasnip = "[Snip]",
						buffer = "[Buf]",
						path = "[Path]",
					},
				}),
			},

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			experimental = { ghost_text = false }, -- stable, avoids crashes
		})

		-- Supermaven auto start/stop
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				local ft = vim.bo.filetype
				if not vim.tbl_contains({ "cpp", "markdown", "text" }, ft) then
					if not sm_api.is_running() then
						sm_api.start()
					end
				else
					if sm_api.is_running() then
						sm_api.stop()
					end
				end
			end,
		})

		-- Supermaven toggle command
		vim.api.nvim_create_user_command("SupermavenToggle", function()
			if sm_api.is_running() then
				sm_api.stop()
				vim.notify("Supermaven disabled", vim.log.levels.INFO)
			else
				sm_api.start()
				vim.notify("Supermaven enabled", vim.log.levels.INFO)
			end
		end, {})
	end,
}
