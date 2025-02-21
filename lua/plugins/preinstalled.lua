return {
  -- Vim notifications
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
      },
      cmdline = {
        view = "cmdline",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- Let neo-tree act like netrw
      opts.filesystem.hijack_netrw_behavior = "open_current"
    end,
  },
  -- LSP config
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local is_pumvisible = vim.fn.pumvisible
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "<c-k>",
        function()
          vim.notify("Signature Help OR Move up")
          if vim.fn.pumvisible() == 1 then
            -- If popup is visible, move up
            vim.api.nvim_input("<c-p>")
          else
            -- Else, show signature help
            vim.lsp.buf.signature_help()
          end
        end,
        mode = "i",
        desc = "Signature Help OR Move down",
        has = "signatureHelp",
      }
      -- change a keymap
      --keys[#keys + 1] = { "K", "<cmd>echo 'hello'<cr>" }
      -- disable a keymap
      --keys[#keys + 1] = { "K", false }
      -- add a keymap
      --keys[#keys + 1] = { "H", "<cmd>echo 'hello'<cr>" }
    end,
  }, -- LSP config
  --  {
  --  "folke/which-key.nvim",
  --    opts={
  --    }
  --  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options.hover = {
        enabled = true,
        delay = 100,
        reveal = { "close" },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.component_separators = { left = "|", right = "|" }
      opts.options.section_separators = { left = " ", right = " " }
    end,
  },
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "lua",
        "python",
        "query",
        "regex",
      },
    },
  },
}
