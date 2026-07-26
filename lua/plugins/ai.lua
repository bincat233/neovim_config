return {
  --{ import = "lazyvim.plugins.extras.ai.copilot" }, -- copilot
  --{ import = "lazyvim.plugins.extras.ai.avante" }, -- Moved to ../config/lazy.lua
  {
    -- See: https://ravitemer.github.io/mcphub.nvim/configuration.html
    "ravitemer/mcphub.nvim",
    -- Disable if running as root to avoid permission issues with global npm install
    enabled = vim.uv.getuid() ~= 0,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup({
        extensions = {
          --copilotchat = {
          --  enabled = true,
          --  convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
          --  convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
          --  add_mcp_prefix = false, -- Add "mcp_" prefix to function names
          --},
        },
      })
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    init = function()
      local env_files = {
        "~/.config/secret/deepseek.env",
        "~/.config/secret/openai.env",
      }
      for _, path in ipairs(env_files) do
        local f = io.open(vim.fn.expand(path))
        if f then
          for line in f:lines() do
            local key, val = line:match("^(.-)=(.*)$")
            if key and val and vim.env[key] == nil then
              vim.env[key] = val
            end
          end
          f:close()
        end
      end
    end,
    opts = {
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
      end,
      -- Using function prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      provider = "deepseek",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-v4-pro",
          model_names = { "deepseek-v4-flash" },
          extra_request_body = {
            max_tokens = 393216,
            thinking = { type = "enabled" },
          },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      return opts
    end,
  },
}
