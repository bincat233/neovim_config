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
    "folke/snacks.nvim",
    opts = function(_, opts)
      local new_key = {
        icon = " ",
        key = "d",
        desc = "LeetCode",
        --action = ":Leet",
        action = function()
          local bufs = vim.api.nvim_list_bufs()
          for i = 2, #bufs, 1 do
            local b = bufs[i]
            vim.api.nvim_buf_delete(b, {})
          end
          vim.bo[1].buflisted = false
          vim.cmd(":Leet")
        end,
      }
      local keys = opts.dashboard.preset.keys
      if keys ~= nil then
        table.insert(keys, #keys, new_key)
      end
    end,
  },
}
