return {
  {
    "neovim/nvim-lspconfig",
    --version = ">=2.0.0",
    opts = {
      servers = {
        --kotlin_lsp = {},
        kotlin_language_server = {},
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders=true",
            "--fallback-style=llvm",
          },
        },
      },
    },
  },
}
