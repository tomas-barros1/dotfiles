return {
  "windwp/nvim-autopairs",
  config = function(_, opts)
    -- carrega config padrão do AstroNvim
    require("nvim-autopairs").setup(opts)

    -- adiciona regra customizada
    local Rule = require("nvim-autopairs.rule")
    local npairs = require("nvim-autopairs")

    npairs.add_rules({
      Rule("<%", "%>", "eruby"),
    })
  end,
}
