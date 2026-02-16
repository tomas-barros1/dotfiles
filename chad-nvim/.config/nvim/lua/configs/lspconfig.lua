-- Using vim.lsp.config (Neovim 0.11+)

-- TypeScript/JavaScript (ts_ls)
vim.lsp.config.ts_ls = {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
}

-- Enable all LSP servers
vim.lsp.enable({
  "html",
  "cssls",
  "ts_ls",
  "ruby_lsp",
  "kotlin_language_server",
  "emmet_language_server"
})
