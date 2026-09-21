vim.opt.autoread = true
vim.opt.guicursor = ""

-- Reduz atrasos perceptíveis ao digitar e em teclas especiais do terminal.
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10

-- Evita trabalho de diagnósticos enquanto o texto ainda está sendo digitado.
vim.diagnostic.config {
  update_in_insert = false,
  virtual_text = false,
}

-- Arquivos com linhas gigantes não devem consumir todo o tempo de redraw.
vim.opt.synmaxcol = 200

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})
