vim.g.mapleader = " "

-- Open Nvim Explorer
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

-- Open file on the right with a vertical split
vim.keymap.set('n', '<leader>vr', function()
    local file = vim.fn.input("File to open on the right: ")
    if file ~= "" then
        -- Get the directory of the current buffer
        local dir = vim.fn.expand("%:p:h")
        -- Build full path
        local filepath = dir .. "/" .. file
        -- Open in right split with width 80
        vim.cmd("rightbelow vsplit +80 " .. filepath)
    end
end)
-- Resize vertical splits
vim.keymap.set('n', '<C-Left>', ':vertical resize -5<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +5<CR>')

-- Resize horizontal splits
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>')
