-- To configure each LSP server, create config file in ~/.config/nvim/lua/lsp/config
-- The file name must be the same as the server name in this url (Use `gx` to open the link)
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers

local mason = require("mason")
local mason_config = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local keys = require("keybindings")

-- Check if mason, mason-lspconfig, and lspconfig are installed
if not mason or not mason_config or not lspconfig then
  vim.notify("mason, mason-lspconfig, and lspconfig are required for this plugin to work", vim.log.levels.ERROR)
  return
end

-- :h mason-default-settings
-- ~/.local/share/nvim/mason
mason.setup({
  ui = {
    --border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- mason-lspconfig uses the `lspconfig` server names in the APIs it exposes - not `mason.nvim` package names
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
mason_config.setup({
  ensure_installed = {
    "gopls",
    "bashls",
    "clangd",
    "cmake",
    "rust_analyzer",
    "lua_ls",
  },
})

local lua_runtime_path = vim.split(package.path, ";")
table.insert(lua_runtime_path, "lua/?.lua")
table.insert(lua_runtime_path, "lua/?/init.lua")

require("lsp-setup").setup({
  -- Default mappings
  -- gD = 'lua vim.lsp.buf.declaration()',
  -- gd = 'lua vim.lsp.buf.definition()',
  -- gt = 'lua vim.lsp.buf.type_definition()',
  -- gi = 'lua vim.lsp.buf.implementation()',
  -- gr = 'lua vim.lsp.buf.references()',
  -- K = 'lua vim.lsp.buf.hover()',
  -- ['<C-k>'] = 'lua vim.lsp.buf.signature_help()',
  -- ['<space>rn'] = 'lua vim.lsp.buf.rename()',
  -- ['<space>ca'] = 'lua vim.lsp.buf.code_action()',
  -- ['<space>f'] = 'lua vim.lsp.buf.formatting()',
  -- ['<space>e'] = 'lua vim.diagnostic.open_float()',
  -- ['[d'] = 'lua vim.diagnostic.goto_prev()',
  -- [']d'] = 'lua vim.diagnostic.goto_next()',
  default_mappings = true,
  -- Custom mappings, will overwrite the default mappings for the same key
  -- Example mappings for telescope pickers:
  -- gd = 'lua require"telescope.builtin".lsp_definitions()',
  -- gi = 'lua require"telescope.builtin".lsp_implementations()',
  -- gr = 'lua require"telescope.builtin".lsp_references()',
  mappings = {},
  -- Global on_attach
  on_attach = function(client, bufnr)
    -- NOTE: Set key in ~/.config/nvim/lua/keybindings.lua
    keys.lsp_on_attach_keys_setup(bufnr)
    -- Support custom the on_attach function for global
    -- Formatting on save as default
    --require('lsp-setup.utils').format_on_save(client)
    -- Disable formatting by default because we have null-ls
    require("lsp-setup.utils").disable_formatting(client)
    -- For Signature Help (函数参数提示)
    require("lsp.lsp_signature").setup(bufnr)
    ---- 临时的变量高亮方案
    --if client.server_capabilities.documentHighlightProvider then
    --	vim.api.nvim_exec([[
    --	]], false)
    --	local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", {})
    --	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      --		buffer = 0,
      --		group = group,
      --		callback = function()
        --			vim.lsp.buf.document_highlight()
        --		end,
        --	})
        --	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
          --		buffer = 0,
          --		group = group,
          --		callback = function()
            --			vim.lsp.buf.clear_references()
            --		end,
            --	})
            --end
          end,
          -- Global capabilities
          capabilities = vim.lsp.protocol.make_client_capabilities(),
          flags = { debounce_text_changes = 150 },
          -- Configuration of LSP servers
          servers = {
            -- Install LSP servers automatically
            -- LSP server configuration please see: 
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            -- https://github.com/nshen/learn-neovim-lua/tree/v2/lua/lsp/config
            -- pylsp = {},
            rust_analyzer = {
              settings = {
                ["rust-analyzer"] = {
                  cargo = { loadOutDirsFromCheck = true },
                  procMacro = { enable = true },
                },
              },
            },
            lua_ls = {
              settings = {
                Lua = {
                  runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = lua_runtime_path,
                  },
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                  },
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  -- Do not send telemetry data containing a randomized but unique identifier
                  telemetry = { enable = false },
                },
              },
            },
            clangd = {
              cmd = { "/usr/bin/clangd", "--background-index", "--offset-encoding=utf-16" },
              capabilities = { offsetEncoding = "utf-16" },
            },
            cssls = {
              settings = {
                css = {
                  validate = true,
                  -- tailwindcss
                  lint = { unknownAtRules = "ignore" },
                },
                less = { validate = true, lint = { unknownAtRules = "ignore" } },
                scss = { validate = true, lint = { unknownAtRules = "ignore" } },
              },
            },
            bashls = {
              cmd = { "bash-language-server", "start" },
              filetypes = { "sh", "zsh" },
              root_dir = function(fname)
                return lspconfig.util.root_pattern(".git")(fname) or lspconfig.util.path.dirname(fname)
              end,
            },
            gopls = {
              --flags = common.flags,
              on_attach = function(_, bufnr)
                --common.keyAttach(bufnr)
                -- common.disableFormat(client)
              end,
              -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
              settings = {
                gopls = {
                  analyses = {
                    unusedparams = true,
                  },
                  staticcheck = true,
                },
              },
            },
          },
        })

        -- Setup LSP UI
        require("lsp.ui")

        -- Setup null-ls
        require("lsp.null-ls")

        -- Setup keybindings
        keys.lsp_globe_keys_setup()
