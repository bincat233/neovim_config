local ascii_art = {
  [[                                   ]],
  [[                                   ]],
  [[                                   ]],
  [[                                   ]],
  [[                                   ]],
  [[                                   ]],
  [[                                   ]],
  [[                                   ]],
  [[          ▀████▀▄▄              ▄█ ]],
  [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
  [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
  [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
  [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
  [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
  [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
  [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
  [[   █   █  █      ▄▄           ▄▀   ]],
  [[                                   ]],
  [[                                   ]],
}
return {
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      -- Set a custom header color, when the dashboard is ready
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(event)
          --if vim.api.nvim_get_hl(0, { name = "DashboardHeader" }) then
          --  return
          --end
          --local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
          if event.data == "dashboard-nvim" then
            local hex_icon = utils.mix_colors_in_lab("String", "Normal"):to_hex()
            local hex_pikachu = utils.mix_colors_in_lab("#f8ec99", "Normal", -0.2):to_hex()
            local hex_key = utils.mix_colors_in_lab(hex_pikachu, "Normal"):to_hex()
            vim.api.nvim_set_hl(0, "DashboardHeader", { fg = hex_pikachu })
            vim.api.nvim_set_hl(0, "DashboardKey", { fg = hex_key })
            vim.api.nvim_set_hl(0, "DashboardIcon", { fg = hex_icon })
          end
        end,
      })
      opts.config.header = ascii_art
    end,
  },
}
