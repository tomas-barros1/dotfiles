-- Odin language support: syntax highlighting, LSP, formatting and run/build

local function odin_task(name, subcmd)
  return function()
    local root = vim.fs.root(0, { "ols.json", ".git" })
    if not root then
      vim.notify("Odin project root not found", vim.log.levels.ERROR)
      return
    end

    vim.cmd "write"

    local overseer = require "overseer"
    local task = overseer.new_task {
      name = name,
      cmd = { "odin", subcmd, "src" },
      cwd = root,
    }
    task:start()
    overseer.open { enter = false } -- abre o painel sem roubar o foco
  end
end

return {
  {
    "stevearc/overseer.nvim",
    opts = {},
    keys = {
      { "<F6>", odin_task("Odin Run", "run"), ft = "odin", desc = "Run Odin project" },
      { "<F7>", odin_task("Odin Build", "build"), ft = "odin", desc = "Build Odin project" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "odin" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        odin = { "odinfmt" },
      },
    },
  },
}
