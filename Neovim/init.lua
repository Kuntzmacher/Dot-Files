-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- set jk to escape
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

if vim.g.vscode then
  vim.keymap.set("n", "<leader><leader>", function()
    vim.fn.VSCodeNotify("workbench.action.quickOpen")
  end, { noremmap = true, silent = true })
end
