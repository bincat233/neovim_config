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
    --local bg = utils.get_highlight_hex("Normal", "bg")
    --local random_color = utils.rgb_to_hex(utils.generate_distinct_color_in_lab(bg, 75))
    --vim.api.nvim_set_hl(0, group, { fg = random_color })
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
  {
    "hasansujon786/nvim-navbuddy",
    cmd = "Navbuddy",
    opts = { lsp = { auto_attach = true } },
  },
  --{ import = "lazyvim.plugins.extras.editor.navic" }, --winbar
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
    opts = {
      winbar = {
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
              ---- TODO: What if we switch to another window?
              ---- Show --> hide
              --if vim.g.navicshown and navbar == "" then
              --  vim.g.navicshown = false
              --  if w_height - c_height > scrolloff then
              --    -- Curser not on the bottom 5 lines (弹开cursor)
              --    utils.scroll_viewport(-1)
              --  else
              --    -- 反向移动, 我弹开我自己
              --    utils.scroll_viewport(scrolloff + c_height - vim.fn.winheight(0))
              --  end
              ---- Hide --> show
              --elseif not vim.g.navicshown and navbar ~= "" then
              --  vim.g.navicshown = true
              --  utils.scroll_viewport(1)
              --end
              navbar = navbar:gsub("(#NavicIcons.-#)", "%1 ", 1)
              return navbar
            end,
            -- Determines if it should show up
            cond = function()
              return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
            end,
          },
        },
      },
      sections = {
        lualine_x = {
          {
            function()
              local ok, config = pcall(require, "avante.config")
              if not ok then
                return ""
              end
              local provider = config.provider
              local provider_cfg = config.get_provider_config(provider)
              if not provider_cfg then
                return ""
              end
              local model = provider_cfg.model or provider
              -- Shorten common model names for statusline display
              local display = model
                :gsub("%-20%d+%-%d+%-%d+", "") -- strip date versions
                :gsub("%-preview.*", "") -- strip preview suffixes
                :gsub("claude%-sonnet%-4", "sonnet4")
                :gsub("claude%-opus%-4", "opus4")
                :gsub("claude%-haiku%-4", "haiku4")
                :gsub("gpt%-4o%-codex", "gpt4o-codex")
                :gsub("gpt%-4o%-mini", "gpt4o-mini")
                :gsub("gpt%-4o", "gpt4o")
                :gsub("deepseek%-v4%-pro", "ds-v4p")
                :gsub("deepseek%-v4%-flash", "ds-v4f")
                :gsub("deepseek%-chat", "ds-chat")
                :gsub("deepseek%-v3", "ds-v3")
                :gsub("deepseek%-r1", "ds-r1")
                :gsub("gemini%-2.5%-pro", "gem25pro")
                :gsub("gemini%-2.5%-flash", "gem25flash")
                :gsub("kimi%-k2", "kimi-k2")
              return "󰧑 " .. display
            end,
            cond = function()
              return package.loaded["avante.config"] ~= nil
            end,
            on_click = function()
              require("avante.api").select_model()
            end,
          },
          {
            function()
              -- Check if MCPHub is loaded
              if not vim.g.loaded_mcphub then
                return "󰐻 -"
              end

              local count = vim.g.mcphub_servers_count or 0
              local status = vim.g.mcphub_status or "stopped"
              local executing = vim.g.mcphub_executing

              -- Show "-" when stopped
              if status == "stopped" then
                return "󰐻 -"
              end

              -- Show spinner when executing, starting, or restarting
              if executing or status == "starting" or status == "restarting" then
                local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                return "󰐻 " .. frames[frame]
              end

              return "󰐻 " .. count
            end,
            color = function()
              if not vim.g.loaded_mcphub then
                return { fg = "#6c7086" } -- Gray for not loaded
              end

              local status = vim.g.mcphub_status or "stopped"
              if status == "ready" or status == "restarted" then
                return { fg = "#50fa7b" } -- Green for connected
              elseif status == "starting" or status == "restarting" then
                return { fg = "#ffb86c" } -- Orange for connecting
              else
                return { fg = "#ff5555" } -- Red for error/stopped
              end
            end,
            on_click = function()
              local State = require("mcphub.state")
              if State.ui_instance then
                State.ui_instance:toggle()
              end
            end,
          },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Unset the default config of navbar
      opts.sections.lualine_c[5] = nil
      --require("local.debug").obj_dump(opts)
    end,
  },
}
