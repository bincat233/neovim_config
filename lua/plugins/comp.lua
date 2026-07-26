return {
  {
    "saghen/blink.cmp",
    version = "*",
    build = function()
      require("blink.cmp").build():wait(60000)
    end,
    dependencies = { "saghen/blink.lib" },
    opts = function(_, opts)
      opts.completion.list = { selection = { preselect = false } }
      opts.keymap = {
        preset = "enter",
        --["<Tab>"] = { "select_and_accept" },
        --["<S-Tab>"] = { "select_prev" },
        ["<C-y>"] = {
          [1] = "select_and_accept",
        },
        ["<C-l>"] = { [1] = "select_and_accept" },
        ["<C-j>"] = { "select_next" },
        ["<C-k>"] = { "select_prev" },
      }

      -- Merge sources
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        default = { "lsp", "path", "snippets", "buffer", "dadbod", "copilot", "avante" },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {},
          },
        },
      })
      --obj_dump(opts)
    end,
  },
}
