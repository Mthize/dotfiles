return {
    "echasnovski/mini.icons",
    version = false,
    lazy = true,
    config = function()
        require("mini.icons").setup({
            style = "glyph", -- or "ascii" if you prefer a minimal look

            extension = {
                lua  = { glyph = "", hl = "MiniIconsBlue" },
                json = { glyph = "", hl = "MiniIconsYellow" },
                lock = { glyph = "", hl = "MiniIconsRed" },
            },

            filetype = {
                markdown = { glyph = "", hl = "MiniIconsYellow" },
                python   = { glyph = "", hl = "MiniIconsBlue" },
            },
        })

        -- Kanagawa-consistent icon colors
        vim.api.nvim_set_hl(0, "MiniIconsBlue",   { fg = "#7E9CD8" })   -- crystal blue
        vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = "#E6C384" })   -- golden sand
        vim.api.nvim_set_hl(0, "MiniIconsRed",    { fg = "#E46876" })   -- sakura red
    end,
}

