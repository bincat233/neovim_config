return {
  {
    "neovim/nvim-lspconfig",
    --version = ">=2.0.0",
    opts = {
      servers = {
        --kotlin_lsp = {},
        kotlin_language_server = {},
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    --version = ">=2.0.0",
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
  },
  {
    "mason-org/mason-lspconfig.nvim",
    --version = ">=2.0.0",
    --opts = function(_, opts)
    --  --obj_dump(opts)
    --end,
  },
  {
    "mason-org/mason.nvim",
    --version = ">=2.0.0",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
