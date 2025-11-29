return {
    -- Tokyonight (backup)
    {
        "folke/tokyonight.nvim",
        config = function()
            -- colorscheme not applied by default
            -- vim.cmd.colorscheme "tokyonight"
        end
    },

    -- Kanagawa Dragon
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require('kanagawa').setup({
                compile = true,
                undercurl = true,
                commentStyle = { italic = true },
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                transparent = false,       -- solid background
                dimInactive = false,
                terminalColors = true,
                theme = "dragon",          -- dragon theme
                background = { dark = "dragon", light = "lotus" },
                overrides = function(colors)
                    -- solid popup menu using dragon palette
                    return {
                        Pmenu      = { fg = colors.palette.fujiWhite, bg = colors.palette.sumiInk2 },
                        PmenuSel   = { fg = colors.palette.fujiWhite, bg = colors.palette.waveBlue2 },
                        PmenuSbar  = { bg = colors.palette.sumiInk3 },
                        PmenuThumb = { bg = colors.palette.waveBlue2 },
                    }
                end,
            })
            vim.cmd("colorscheme kanagawa")
        end
    },

    -- Lualine
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            theme = 'kanagawa',
        }
    },

    -- Gruvbox (backup)
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('gruvbox').setup({})
        end
    }
}
