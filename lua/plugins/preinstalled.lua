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
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      utils.obj_dump(opts)
      local cmp = require("cmp")
      local function conferm_selection(fallback)
        if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
          LazyVim.create_undo()
          if cmp.confirm(opts) then
            return
          end
        end
        return fallback()
      end
      opts.preselect = cmp.PreselectMode.None -- Don't preselect first item
      opts.completion = { completeopt = "menu,menuone,noselect" } -- Don't preselect first item
      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        -- Remove default <CR> mapping
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Don't select first item
        ["<C-h>"] = cmp.mapping.abort(),
        ["<C-c>"] = cmp.mapping.abort(),
        ["<C-l>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true, -- Perselect first item
        }),
        -- Allow scrolling in documentation windows
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-8), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(8), { "i", "c" }),
        -- Navigation
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous
        ["<C-j>"] = cmp.mapping.select_next_item(), -- Next
      })
      --obj_dump(opts.completion)
    end,
  }, -- nvim-cmp (Completion)
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
