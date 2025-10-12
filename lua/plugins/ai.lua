return {
  { "zbirenbaum/copilot-cmp" },
  { "nvim-cmp" },
}

--return {
--  {
--    "Exafunction/codeium.nvim",
--    dependencies = {
--      "nvim-lua/plenary.nvim",
--      "hrsh7th/nvim-cmp",
--    },
--
--    opts = function(_, opts)
--      opts.workspace_root = {
--        use_lsp = true,
--        find_root = require("lazyvim.util").root,
--        paths = {
--          ".bzr",
--          ".git",
--          ".hg",
--          ".svn",
--          ".root",
--          "_FOSSIL_",
--          "package.json",
--        },
--      }
--      --obj_dump(opts)
--    end,
--  },
--}
