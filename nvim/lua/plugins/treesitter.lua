---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "html",
      "ruby",
      "javascript",
      "typescript",
      "css",
      "json",
      "markdown",
      "embedded_template",
    },
    highlight = {
      enable = true,
    },
  }
}
