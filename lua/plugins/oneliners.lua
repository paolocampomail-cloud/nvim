return {
    { -- This helps with php/html for indentation
        'captbaritone/better-indent-support-for-php-with-html',
    },

    { -- This helps with ssh tunneling and copying to clipboard
        'ojroques/vim-oscyank',
    },

    { -- This generates docblocks
        'kkoomen/vim-doge',
        build = ':call doge#install()',
    },

    { -- Git plugin
        'tpope/vim-fugitive',
    },

    { -- Show historical versions of the file locally
        'mbbill/undotree',
    },

    { -- Show CSS Colors
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup({})
        end,
    },

    { -- Highlight color codes in files
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({})
        end,
    },

    { -- Popup color picker
        "ziontee113/color-picker.nvim",
        config = function()
            require("color-picker").setup()
            vim.keymap.set("n", "<leader>cp", "<cmd>PickColor<CR>")
            vim.keymap.set("i", "<C-c>", "<cmd>PickColorInsert<CR>")
        end,
    },
}

