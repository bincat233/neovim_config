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
local function set_cs(cs)
  local colorscheme = "default"
  local status_ok, _ = pcall(vim.cmd.colorscheme, cs)
  if status_ok then
    colorscheme = cs
  end
  if colorscheme == "default" then
    vim.notify("Preferred colorscheme " .. cs .. " not found, fallback to default")
  end
end

-- Check if running under Linux console
local function is_linux_console()
  return not os.getenv("DISPLAY") and not os.getenv("SSH_TTY") and not os.getenv("WAYLAND_DISPLAY")
end

-- When developing vim colorsheme
local function in_project(name)
  return vim.fn.getcwd():find(name)
end

-- Check if the system is in dark mode
local _is_dark_cached = nil
local function is_system_dark()
  if _is_dark_cached ~= nil then
    return _is_dark_cached
  end
  local dark = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme"):find("dark")
    or vim.fn.system("gsettings get org.gnome.desktop.interface gtk-theme"):find("dark")
    or vim.fn.system("gsettings get org.gnome.desktop.interface gtk-color-scheme"):find("dark")
    or os.getenv("UI_DARK_MODE") == "true"
  _is_dark_cached = dark
  return dark
end

_G.is_system_dark = is_system_dark

-- Set colorscheme based on the environment
local background = is_system_dark() and "dark" or "light"
if is_linux_console() then -- If under TTY
  spec[1].opts.colorscheme = "solarized"
  vim.opt.termguicolors = false
  vim.o.background = "dark"
elseif in_project("seoul256") then
  spec[1].opts.colorscheme = "seoul256"
  vim.o.background = background
else -- GUI
  --spec[1].opts.colorscheme = is_system_dark() and "github_dark" or "github_light"
  spec[1].opts.colorscheme = "pywal16"
  spec[2].opts.options.theme = "pywal16-nvim"
  vim.o.background = background
end

-- Create user commands to switch colorscheme and background
--vim.api.nvim_create_user_command("DarkMode", _G.set_dark, {})

return spec
