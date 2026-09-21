return {
  -- Odin Language Server (OLS): diagnóstico, navegação, snippets e formatação.
  -- `ols`/`odinfmt` instalados via pacman/AUR estão no PATH; o astrolsp só ativa o server
  -- (via vim.lsp.enable, resolvendo `ols` no /usr/bin).
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      servers = { "ols" },
    },
  },
  -- Tree-sitter: syntax highlighting e indentação para Odin
  {
    "AstroNvim/astrocore",
    optional = true,
    ---@type AstroCoreOpts
    opts = {
      treesitter = { ensure_installed = { "odin" } },
    },
  },
  -- Instalação automática via Mason — DESATIVADA porque ols/odinfmt vêm do pacman.
  -- Em máquinas sem o pacote do sistema, reative os blocos abaixo:
  -- {
  --   "mason-org/mason-lspconfig.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed =
  --       require("astrocore").list_insert_unique(opts.ensure_installed, { "ols" })
  --   end,
  -- },
  -- {
  --   "WhoIsSethDaniel/mason-tool-installer.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed =
  --       require("astrocore").list_insert_unique(opts.ensure_installed, { "ols" })
  --   end,
  -- },
}