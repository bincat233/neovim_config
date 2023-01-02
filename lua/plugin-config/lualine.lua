-- 如果找不到lualine 组件，就不继续执行
local lualine = safe_require("lualine")
if not lualine then return end

lualine.setup({
  options = {
    --theme = "iceberg",
    component_separators = { left = "|", right = "|" },
    -- https://github.com/ryanoasis/powerline-extra-symbols
    section_separators = { left = " ", right = "" },
		globalstatus = true,
  },
  extensions = { "nvim-tree", "toggleterm" },
  sections = {
    lualine_c = {
      "filename",
      {
        "lsp_progress",
        spinner_symbols = { " ", " ", " ", " ", " ", " " },
      },
    },
    lualine_x = {
      "filesize",
      {
        "fileformat",
        symbols = {
          unix = ' LF', -- e712
          dos  = ' CRLF', -- e70f
          mac  = ' CR', -- e711
        },
      },
      "encoding",
      "filetype",
    },
  },
})

vim.o.showmode = false -- 不显示 vim 原生的模式提示
