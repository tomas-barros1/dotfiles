return {
  "nvim-mini/mini.move",
  version = false,
  opts = {
    mappings = {
      left = "<M-h>",
      right = "<M-l>",
      down = "<M-j>",
      up = "<M-k>",
      line_left = "<M-h>",
      line_right = "<M-l>",
      line_down = "<M-j>",
      line_up = "<M-k>",
    },
  },

  config = function(_, opts)
    require("mini.move").setup(opts)

    -- Normal mode
    vim.keymap.set("n", "<M-Down>", "<M-j>", { remap = true })
    vim.keymap.set("n", "<M-Up>", "<M-k>", { remap = true })

    -- Visual mode
    vim.keymap.set("v", "<M-Down>", "<M-j>", { remap = true })
    vim.keymap.set("v", "<M-Up>", "<M-k>", { remap = true })
  end,
}
