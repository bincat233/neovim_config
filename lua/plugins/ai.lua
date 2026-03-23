return {
  --{ import = "lazyvim.plugins.extras.ai.copilot" }, -- copilot
  --{ import = "lazyvim.plugins.extras.ai.avante" }, -- Moved to ../config/lazy.lua
  {
    -- See: https://ravitemer.github.io/mcphub.nvim/configuration.html
    "ravitemer/mcphub.nvim",
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
