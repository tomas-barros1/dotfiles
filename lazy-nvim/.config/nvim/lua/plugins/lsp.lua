return {
  "nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      rubocop = { enabled = false },
      bashls = {
        mason = false,
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/bash-language-server", "start" },
      },

    },
  },
}
