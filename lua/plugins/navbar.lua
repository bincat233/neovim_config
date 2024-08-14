local function set_hl()
  local hl_groups = {
    "NavicIconsFile",
    "NavicIconsModule",
    "NavicIconsNamespace",
    "NavicIconsPackage",
    "NavicIconsClass",
    "NavicIconsMethod",
    "NavicIconsProperty",
    "NavicIconsField",
    "NavicIconsConstructor",
    "NavicIconsEnum",
    "NavicIconsInterface",
    "NavicIconsFunction",
    "NavicIconsVariable",
    "NavicIconsConstant",
    "NavicIconsString",
    "NavicIconsNumber",
    "NavicIconsBoolean",
    "NavicIconsArray",
    "NavicIconsObject",
    "NavicIconsKey",
    "NavicIconsNull",
    "NavicIconsEnumMember",
    "NavicIconsStruct",
    "NavicIconsEvent",
    "NavicIconsOperator",
    "NavicIconsTypeParameter",
  }

  -- Change random seed
  math.randomseed(os.time())
  for _, group in ipairs(hl_groups) do
    -- Set to a random color
    local bg = utils.get_highlight_hex("Normal", "bg")
    local random_color = utils.rgb_to_hex(utils.generate_distinct_color_in_lab(bg, 75))
    vim.api.nvim_set_hl(0, group, { fg = random_color })
  end
  vim.api.nvim_set_hl(0, "NavicText", { link = "@text" })
  vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Comment" })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(event)
    if event.data == "nvim-navic" then
      set_hl()
    end
  end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    set_hl()
  end,
})
return {
  { import = "lazyvim.plugins.extras.editor.navic" }, --winbar
  {
    "SmiteshP/nvim-navic",
    opts = function(_, opts)
      opts.separator = "  "
      opts.highlight = true
      opts.depth_limit_indicator = "  "
      opts.click = true
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.winbar = {
        lualine_c = {
          {
            function()
              local navbar = require("nvim-navic").get_location()
              --local f_last_line = vim.fn.line("$") -- 获取文件的最后一行(绝对)
              local w_first_line = vim.fn.line("w0") -- 获取当前窗口的第一个可见行(绝对)
              --local w_last_line = vim.fn.line("w$") -- 获取当前窗口的最后一个可见行
              local w_height = vim.fn.winheight(0) -- 获取当前窗口的高度 (行数, 仅内容)
              local c_height = vim.fn.winline() -- cursor所在高度(相对)
              local scrolloff = vim.o.scrolloff -- 获取当前的scrolloff值
              if w_first_line == 1 and vim.g.navicshown and navbar == "" then
                navbar = "%#NavicSeparator# %*%#NavicText# %*"
              end
              -- TODO: What if we switch to another window?
              -- Show --> hide
              if vim.g.navicshown and navbar == "" then
                vim.g.navicshown = false
                if w_height - c_height > scrolloff then
                  -- Curser not on the bottom 5 lines (弹开cursor)
                  utils.scroll_viewport(-1)
                else
                  -- 反向移动, 我弹开我自己
                  utils.scroll_viewport(scrolloff + c_height - vim.fn.winheight(0))
                end
              -- Hide --> show
              elseif not vim.g.navicshown and navbar ~= "" then
                vim.g.navicshown = true
                utils.scroll_viewport(1)
              end
              navbar = navbar:gsub("(#NavicIcons.-#)", "%1 ", 1)
              return navbar
            end,
            -- Determines if it should show up
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          },
        },
      }
    end,
  },
}
