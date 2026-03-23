return {
  {
    -- Chinese word segmentation plugin
    "kkew3/jieba.vim",
    event = "VeryLazy",
    tag = "v1.0.5",
    build = "./build.sh",
    init = function()
      vim.g.jieba_vim_lazy = 1
      vim.g.jieba_vim_keymap = 1
    end,
  },
  {
    -- Switch between Chinese and English input method in insert mode
    "h-hg/fcitx.nvim",
    event = "VeryLazy",
  },
}
