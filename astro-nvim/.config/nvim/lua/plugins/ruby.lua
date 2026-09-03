return {
  {
    "AstroNvim/astrocore",
    optional = true,
    opts = {
      treesitter = { ensure_installed = { "ruby" } },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "ruby_lsp" })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop", "standardrb" },
      },
    },
  },
}
