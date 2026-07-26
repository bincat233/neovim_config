local function read_ascii(name)
  local path = vim.fn.stdpath("config") .. "/asciiart/" .. name

  local f = io.open(path, "r")
  if not f then
    return ""
  end
  local content = f:read("*a")
  f:close()
  return content
end

return {
  {
    "folke/snacks.nvim",
    --disable = true,
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      -- Monā / Pikachu / NeoVim1
      opts.dashboard.preset.header = read_ascii("Monā")
      opts.dashboard.formats = {
        header = { "%s", align = "center" },
      }
      return opts
    end,
  },
}
