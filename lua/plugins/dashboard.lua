local ascii_art = {
  [[
                      ▀████▀▄▄              ▄█ 
                        █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ 
                ▄        █          ▀▀▀▀▄  ▄▀  
               ▄▀ ▀▄      ▀▄              ▀▄▀  
              ▄▀    █     █▀   ▄█▀▄      ▄█    
              ▀▄     ▀▄  █     ▀██▀     ██▄█   
               ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  
                █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  
               █   █  █      ▄▄           ▄▀   
]],
}
return {
  {
    "folke/snacks.nvim",
    --disable = true,
    opts = function(_, opts)
      opts.dashboard.preset.header = ascii_art
      opts.dashboard.formats = {
        header = { "%s", align = "center" },
      }
      -- Set a custom header color, when the dashboard is ready
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(event)
          if event.data == "snacks.nvim" then
            local hex_bg = string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg)
            local hex_pikachu = utils.mix_colors_in_lab("#f8ec99", hex_bg, -0.2):to_hex()
            vim.api.nvim_set_hl(0, "SnacksDashboardNormal", { fg = hex_pikachu })
            if not vim.api.nvim_get_hl(0, { name = "SnacksDashboardHeader" }) then
              vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = hex_pikachu })
            end
            if not vim.api.nvim_get_hl(0, { name = "SnacksDashboardIcon" }) then
              local hex_icon = utils.mix_colors_in_lab("String", "Normal"):to_hex()
              vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = hex_icon })
            end
            if not vim.api.nvim_get_hl(0, { name = "SnacksDashboardKey" }) then
              local hex_key = utils.mix_colors_in_lab(hex_pikachu, "Normal"):to_hex()
              vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = hex_key })
            end
          end
        end,
      })
    end,
  },
}
