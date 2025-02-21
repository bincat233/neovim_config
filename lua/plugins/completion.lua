return {
  {
    "saghen/blink.cmp",
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
    end,
  },
}
