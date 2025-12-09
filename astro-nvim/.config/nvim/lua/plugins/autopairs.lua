return {
  "windwp/nvim-autopairs",
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)

    local Rule = require("nvim-autopairs.rule")
    local npairs = require("nvim-autopairs")

    npairs.add_rules({
      Rule("<%", "%>", "eruby"),
    })
  end,
}
