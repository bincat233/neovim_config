local spec = {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = nil,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = { options = {} },
  },
  -- add colorscheme
  { "oahlen/iceberg.nvim" },
  --{ "ellisonleao/gruvbox.nvim" },
  --{
  --  "folke/tokyonight.nvim",
  --  lazy = false,
  --  priority = 1000,
  --  opts = {},
  --},
  {
    "uZer/pywal16.nvim",
    -- for local dev replace with:
    -- dir = '~/your/path/pywal16.nvim',
    --config = function()
    --  vim.cmd.colorscheme("pywal16")
    --end,
  },
  --{ "altercation/vim-colors-solarized" }, -- Has good support under TTYs
  { "maxmx03/solarized.nvim" },
  --{"shaunsingh/seoul256.nvim"}, -- nvim port of seoul256, but without light theme
  --{"cocopon/iceberg.vim"}, -- My favorite colorscheme with best light theme
  --{ "junegunn/seoul256.vim" }, -- Low contrast colorscheme
  --{ "shaunsingh/seoul256.nvim" },
  --{ "NLKNguyen/papercolor-theme" },
  --{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "projekt0n/github-nvim-theme" },
  --{ dir = "~/Projects/seoul256.nvim" },
  { "bincat233/seoul256.nvim" },
}
local darkman_spec = {
  "4e554c4c/darkman.nvim",
  event = "VimEnter",
  build = "go build -o bin/darkman.nvim",
  opts = {
    change_background = true,
    send_user_event = false,
    colorscheme = nil, -- can be { dark = "x", light = "y" }
  },
}
local utils = require("local.utils")

-- When developing vim colorsheme
local function in_project(name)
  return vim.fn.getcwd():find(name)
end

-- Set colorscheme based on the environment
local function set_colorscheme()
  -- If under TTY
  if utils.get_env() == "linux_console" then
    spec[1].opts.colorscheme = "solarized"
    vim.opt.termguicolors = false
    vim.o.background = "dark"
    return
  end
  -- After this point it must has somekind of GUI
  if in_project("seoul256") then
    darkman_spec.opts.colorscheme = "seoul256"
    return
  end
  if utils.get_env() == "windows" or utils.get_env() == "macos" then
    spec[1].opts.colorscheme = "github_dark"
    return
  end
  -- Definitely under Linux GUI, try to use darkman.nvim to sync with system theme
  spec[#spec + 1] = darkman_spec
  spec[1].opts.colorscheme = "pywal16"
  spec[2].opts.options.theme = "pywal16-nvim"
end

set_colorscheme()

return spec
