return {
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        -- Python: pytest / unittest
        ["neotest-python"] = {},
        -- Fallback for any runner supported by vim-test
        ["neotest-vim-test"] = {
          ignore_file_types = { "python", "lua" },
        },
      },
    },
    dependencies = {
      {
        "vim-test/vim-test",
        cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
        keys = {
          { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Nearest (vim-test)" },
          { "<leader>tf", "<cmd>TestFile<cr>", desc = "File (vim-test)" },
          { "<leader>tu", "<cmd>TestSuite<cr>", desc = "Suite (vim-test)" },
          { "<leader>ti", "<cmd>TestLast<cr>", desc = "Last (vim-test)" },
          { "<leader>tg", "<cmd>TestVisit<cr>", desc = "Visit (vim-test)" },
        },
      },
    },
  },
}
