local conf = require("telescope.config").values
local themes = require("telescope.themes")

local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    local opts = themes.get_ivy({ prompt_title = "Working List" })

    require("telescope.pickers").new(opts, {
        finder = require("telescope.finders").new_table({ results = file_paths }),
        previewer = conf.file_previewer(opts),
        sorter = conf.generic_sorter(opts),
    }):find()
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },

    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({})

        local map = function(mode, lhs, rhs, opts)
            opts = opts or {}
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        map("n", "<leader>a", function() harpoon:list():add() end)
        map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        map("n", "<leader>fl", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
        map("n", "<C-p>", function() harpoon:list():prev() end)
        map("n", "<C-n>", function() harpoon:list():next() end)

        for i, key in ipairs({ "h", "t", "n", "s" }) do
            map("n", "<C-" .. key .. ">", function() harpoon:list():select(i) end)
        end
    end,
}
