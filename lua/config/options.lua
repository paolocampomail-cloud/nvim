vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
-- Force add the standard Rust installation path to Neovim's environment
local cargo_bin = vim.fn.expand("$HOME/.cargo/bin")

if vim.fn.isdirectory(cargo_bin) == 1 then
  vim.env.PATH = cargo_bin .. ":" .. vim.env.PATH
end
