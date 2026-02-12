return {
  -- NOTE: Scrollbar
  -- https://github.com/dstein64/nvim-scrollview
  { "RRRRRm/vcat.nvim" },
  --{ dir = "~/Projects/vcat" },
  { "dstein64/nvim-scrollview" },
  -- NOTE: Enhance the experience of marks
  -- https://github.com/chentoast/marks.nvim
  {
    "chentoast/marks.nvim",
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {},
      excluded_buftypes = {},
      bookmark_0 = {
        sign = "⚑",
        virt_text = "hello world",
        annotate = false,
      },
      mappings = {},
    },
  },
  -- NOTE: Translate text
  -- https://github.com/uga-rosa/translate.nvim
  {
    "uga-rosa/translate.nvim",
    opts = {
      default = {
        --command = 'translate',
        --'chatblade -c mini -rno "Please translate the following English sentence to Chinese. Only provide the translated sentence without any additional information:" ',
      },
    },
  },
  { "https://gitlab.com/HiPhish/rainbow-delimiters.nvim" },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "tris203/precognition.nvim",
    opts = {
      startVisible = false,
    },
  },
}
