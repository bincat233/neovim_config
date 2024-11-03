local spec = {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = nil,
    },
  },
  -- add colorscheme
  { "oahlen/iceberg.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "altercation/vim-colors-solarized" }, -- Has good support under TTYs
  --{"shaunsingh/seoul256.nvim"}, -- nvim port of seoul256, but without light theme
  --{"cocopon/iceberg.vim"}, -- My favorite colorscheme with best light theme
  --{ "junegunn/seoul256.vim" }, -- Low contrast colorscheme
  --{ "shaunsingh/seoul256.nvim" },
  { "NLKNguyen/papercolor-theme" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "projekt0n/github-nvim-theme" },
  { dir = "~/Projects/seoul256.nvim" },
}

local function set_cs(cs)
  if type(cs) == "string" then -- No fallbacks
    local status_ok, _ = pcall(vim.cmd.colorscheme, cs)
    if not status_ok then
      error("Colorscheme " .. cs .. " not found.")
    end
  elseif type(cs) == "table" then -- With fallback
    local colorscheme = nil
    for _, cs in ipairs(cs) do
      local status_ok, _ = pcall(vim.cmd.colorscheme, cs)
      if status_ok then
        break
      end
    end
    if colorscheme == nil then
      error("No fallbacks colorscheme found.")
    end
    if colorscheme ~= colorscheme[1] then
      vim.notify("Preferred colorscheme " .. cs[1] .. " not found, fallback to " .. colorscheme)
    end
  end
end

local function set_bg(bg, opt)
  opt = opt or { colorscheme = nil }
  local cs = opt.colorscheme or vim.g.colors_name
  if cs then
    local base_cs = cs:gsub("[-_]dark$", ""):gsub("[-_]light$", "")
    local sub_css = vim.fn.getcompletion(base_cs, "color")
    local target_cs = base_cs
    for _, sub_cs in ipairs(sub_css) do
      if sub_cs:find(bg) then
        target_cs = sub_cs
        break
      end
    end
    vim.cmd.colorscheme(target_cs)
  end
  vim.o.background = bg
end

local function makeSetCsBgFn(cs, bg)
  return function()
    set_cs(cs)
    set_bg(bg, { colorscheme = cs })
  end
end

local function is_system_dark()
  return vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme"):find("dark")
    or vim.fn.system("gsettings get org.gnome.desktop.interface gtk-theme"):find("dark")
    or vim.fn.system("gsettings get org.gnome.desktop.interface gtk-color-scheme"):find("dark")
    or os.getenv("UI_DARK_MODE") == "true"
end

local setters = {
  dark = makeSetCsBgFn("github_dark", "dark"),
  light = makeSetCsBgFn("github_light", "light"),
}
-- Set colorscheme based on the environment
if os.getenv("DISPLAY") == nil and os.getenv("SSH_TTY") == nil then -- If under TTY
  spec[1].opts.colorscheme = function()
    set_cs({ "solarized", "base16-default-dark", "default" }) -- Set colorscheme to solarized
    set_bg("dark")
  end
elseif vim.fn.getcwd():find("seoul256") then
  spec[1].opts.colorscheme = makeSetCsBgFn("seoul256", "dark")
elseif is_system_dark() then -- GUI and dark mode
  spec[1].opts.colorscheme = setters.dark
else -- GUI and light mode
  spec[1].opts.colorscheme = setters.light
end

local function set_dark(dark)
  if dark == 0 or dark == nil or dark == false or dark == "" then
    setters.light()
  else
    setters.dark()
  end
end

_G.set_bg = set_bg
_G.set_cs = set_cs
_G.set_dark = set_dark

return spec
