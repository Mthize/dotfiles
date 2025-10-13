return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"supermaven-inc/supermaven-nvim",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local suggestion = require("supermaven-nvim.completion_preview")

		-- Initialize Supermaven first
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<M-l>", -- Alt+l for full suggestion
				accept_word = "<M-j>", -- Alt+j for single word
				clear_suggestion = "<M-k>", -- Alt+k to clear
			},
			ignore_filetypes = { "cpp", "markdown" },
			color = { suggestion_color = "#FFD700" }, -- Gold color for visibility
			disable_keymaps = true, -- We'll handle keymaps ourselves
		})

		-- Load snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
				autocomplete = {
					cmp.TriggerEvent.TextChanged,
					cmp.TriggerEvent.InsertEnter,
				},
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				-- Enhanced Tab behavior with priority:
				-- 1. CMP selection 2. Snippet expansion 3. Supermaven
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif suggestion.has_suggestion() then
						suggestion.on_accept_suggestion()
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

				-- Dedicated Supermaven keys
				["<M-l>"] = cmp.mapping(function() -- Alt+l accepts full suggestion
					if suggestion.has_suggestion() then
						suggestion.on_accept_suggestion()
					else
						cmp.confirm({ select = true })
					end
				end),

				["<M-j>"] = cmp.mapping(function() -- Alt+j accepts word
					if suggestion.has_suggestion() then
						suggestion.on_accept_word()
					else
						cmp.select_next_item()
					end
				end),

				["<M-k>"] = cmp.mapping(function() -- Alt+k clears suggestion
					suggestion.clear_suggestion()
				end),

				-- Preserved existing keybinds
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({
					select = false,
					behavior = cmp.ConfirmBehavior.Replace,
				}),
			}),
			sources = cmp.config.sources({
				{ name = "supermaven", priority = 1000 }, -- Highest priority
				{ name = "nvim_lsp", priority = 900 },
				{ name = "luasnip", priority = 800 },
				{ name = "buffer", priority = 700 },
				{ name = "path", priority = 600 },
			}),
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
					symbol_map = { Supermaven = " " }, -- Custom icon
					menu = {
						supermaven = "[SM]",
						nvim_lsp = "[LSP]",
						luasnip = "[Snip]",
						buffer = "[Buf]",
						path = "[Path]",
					},
				}),
			},
			experimental = {
				ghost_text = {
					hl_group = "Comment", -- Less distracting ghost text
				},
			},
		})

		-- Smart Supermaven management
		local api = require("supermaven-nvim.api")
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				local ft = vim.bo.filetype
				if not vim.tbl_contains({ "cpp", "markdown" }, ft) then
					if not api.is_running() then
						api.start()
					end
				else
					if api.is_running() then
						api.stop()
					end
				end
			end,
		})

		-- Toggle command
		vim.api.nvim_create_user_command("SupermavenToggle", function()
			if api.is_running() then
				api.stop()
				vim.notify("Supermaven disabled", vim.log.levels.INFO)
			else
				api.start()
				vim.notify("Supermaven enabled", vim.log.levels.INFO)
			end
		end, {})
	end,
}
