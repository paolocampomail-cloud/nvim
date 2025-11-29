vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set('n', '<leader>vr', function()
    local file = vim.fn.input("File to open on the right: ")
    if file ~= "" then
        vim.cmd("vert rightbelow vsplit " .. file)
    end
end)
