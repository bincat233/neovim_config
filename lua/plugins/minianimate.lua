return {
  "echasnovski/mini.animate",
  opts = function(_, opts)
    opts.cursor = {
      -- Whether to enable this animation
      enable = true,

      -- Timing of animation (how steps will progress in time)
      --<function: implements linear total 250ms animation duration>,
      timing = require("mini.animate").gen_timing.linear({ duration = 100, unit = "total" }),
    }
  end,
}
