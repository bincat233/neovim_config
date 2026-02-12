return {
  { "h-hg/fcitx.nvim" },
  -- NOTE: Manage and edit obsidian notes
  -- https://github.com/epwalsh/obsidian.nvim
  {
    enabled = false,
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/notes/",
        },
      },
    },
  },
}
