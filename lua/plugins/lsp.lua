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
