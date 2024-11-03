return {
  -- NOTE: Slove LeetCode problems in Neovim
  -- https://github.com/kawre/leetcode.nvim
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
      --image_support = true,
    },
  },
  -- NOTE: Config dashboard screen
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local new_record = {
        action = "Leet",
        desc = " LeetCode",
        icon = " ",
        key = "d",
        key_format = "  %s",
      }
      local center = opts.config.center
      table.insert(center, #center, new_record)
    end,
  },
}
