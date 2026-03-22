return {
  {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    init = function()
      local existing = vim.g.rainbow_delimiters or {}

      vim.g.rainbow_delimiters = vim.tbl_deep_extend("force", existing, {
        blacklist = { "neo-tree", "neo-tree-preview", "xxd" },
        condition = function(bufnr)
          return vim.bo[bufnr].buftype == ""
        end,
      })
    end,
  },
}
