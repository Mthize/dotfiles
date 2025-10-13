
-- ~/.config/nvim/lua/thapelo/plugins/init.lua

return {
  -- Utility plugins
  { "nvim-lua/plenary.nvim" }, -- lua functions that many plugins use
  { "christoomey/vim-tmux-navigator" }, -- tmux & split window navigation

  -- Bufferline (tabs at the top)
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
      options = {
        mode = "tabs",                -- show buffers as tabs
        separator_style = "slant",    -- slanted separator
        always_show_bufferline = true, -- always visible
        show_buffer_close_icons = true, -- close button on each tab
        show_close_icon = false,      -- hide the main close icon (optional)
        show_tab_indicators = true,   -- indicator for modified/diagnostic buffers
        diagnostics = "nvim_lsp",     -- show LSP errors/warnings on tabs
        indicator = { icon = "▎", style = "icon" },
        modified_icon = "●",
        buffer_close_icon = "",
      },
    },
  },
}

