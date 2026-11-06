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
          before_init = function(params, config)
            local flags, err = require("local.sdcc").fallback_flags(config.root_dir)
            if flags then
              local init_options = vim.tbl_deep_extend("force", config.init_options or {}, {
                fallbackFlags = flags,
              })
              config.init_options = init_options
              params.initializationOptions = init_options
            elseif err then
              vim.schedule(function()
                vim.notify("Unable to configure clangd for SDCC: " .. err, vim.log.levels.WARN)
              end)
            end
          end,
        },
      },
    },
  },
}
