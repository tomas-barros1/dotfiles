return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  config = function()
    require("grug-far").setup {}
  end,
  keys = {
    { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Search & Replace (GrugFar)" },
  },
}
