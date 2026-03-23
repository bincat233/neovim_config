return {
  -- Vim notifications
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
      },
      cmdline = {
        view = "cmdline",
      },
    },
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      input = { enabled = false },
    },
  },

  {
    "mini.hipatterns",
    opts = function(_, opts)
      --require("local.debug").obj_dump(opts)
      --local hi = require("mini.hipatterns")
      opts.highlighters.rrggbbaa = {
        pattern = "#%x%x%x%x%x%x%x%x",
        group = function(_, _, data)
          local match = data.full_match
          local rrggbb = match:sub(1, 7)
          return MiniHipatterns.compute_hex_color_group(rrggbb, "bg")
        end,
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- Let neo-tree act like netrw
      opts.filesystem.hijack_netrw_behavior = "open_current"
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options.hover = {
        enabled = true,
        delay = 100,
        reveal = { "close" },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.component_separators = { left = "|", right = "|" }
      opts.options.section_separators = { left = " ", right = " " }
    end,
  },
}
