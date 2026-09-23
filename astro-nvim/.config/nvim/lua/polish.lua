vim.opt.autoread = true

-- Reduz atrasos perceptíveis ao digitar e em teclas especiais do terminal.
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10
--
-- Arquivos com linhas gigantes não devem consumir todo o tempo de redraw.
vim.opt.synmaxcol = 200

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})
