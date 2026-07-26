return {
  -- Vim notifications
  {
    "folke/noice.nvim",
    event = "VeryLazy",
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
      dashboard = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = false },
      image = { enabled = true },
      explorer = { enabled = true },
      statuscolumn = { enabled = true },
    },
  },

  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_height_window_percentage = 50,
      tmux_passthrough_safeguard = false,
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
