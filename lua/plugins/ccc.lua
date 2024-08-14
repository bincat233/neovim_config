return {
  -- NOTE: Colorizer / Color Picker
  -- https://github.com/uga-rosa/ccc.nvim
  {
    "uga-rosa/ccc.nvim",
    config = function()
      local ccc = require("ccc")
      local opts = {
        highlighter = { auto_enable = true },
        pickers = {
          ccc.picker.hex,
          ccc.picker.css_rgb,
          ccc.picker.css_hsl,
          ccc.picker.css_hwb,
          ccc.picker.css_lab,
          ccc.picker.css_lch,
          ccc.picker.css_oklab,
          ccc.picker.css_oklch,
          require("local.ccc-picker-gtk"),
        },
      }
      ccc.setup(opts)
    end,
  },
}
