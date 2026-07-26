return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- fwcd/kotlin-language-server ships an outdated bundled Kotlin compiler
        -- (reads metadata up to 2.2.0) and floods diagnostics on anything built
        -- with a newer Kotlin compiler (e.g. koog-agents, built with 2.3.x).
        kotlin_language_server = { enabled = false },
        -- JetBrains' official kotlin-lsp instead. nvim-lspconfig's built-in
        -- config expects the binary name `intellij-server`, but Mason installs
        -- it as `kotlin-lsp`, so the cmd needs overriding to match.
        kotlin_lsp = {
          cmd = { "kotlin-lsp", "--stdio" },
          -- already installed via Mason's kotlin-lsp package; skip
          -- mason-lspconfig's automatic_enable (its timing was unreliable)
          -- and have lspconfig enable it directly.
          mason = false,
        },
      },
    },
  },
}
