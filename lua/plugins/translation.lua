return {
  -- NOTE: Translate text
  -- https://github.com/uga-rosa/translate.nvim
  {
    "uga-rosa/translate.nvim",
    keys = {
      { "<C-t>", ":Translate ZH<CR>gv", mode = "v", desc = "Translate selection", silent = false },
      {
        "<C-t>",
        "<Esc>m`V:Translate -output=insert EN<CR>k``a",
        mode = "i",
        desc = "Translate selection",
        silent = false,
      },
      { "<leader>tw", "m`viw:Translate ZH<CR>``", desc = "Translate word under cursor" },
      { "<leader>tt", "m`V:Translate ZH<CR>``", desc = "Translate line under cursor" },
      {
        "<leader>ta",
        function()
          local current_pos = vim.fn.getpos(".")
          vim.cmd("normal! ggVG")
          vim.cmd("Translate -output=split ZH")
          vim.api.nvim_input("<ESC>")
          vim.fn.setpos(".", current_pos)
        end,
        desc = "Translate the page",
      },
    },
    opts = {
      default = {
        --command = 'translate',
        --'chatblade -c mini -rno "Please translate the following English sentence to Chinese. Only provide the translated sentence without any additional information:" ',
      },
    },
  },
}
