-- Plugins settings

-- Plugins stored in ~/.local/share/nvim/site/pack/packer/start
-- Use :PackerSync to install/update plugins

-- And most plugins has a config script stored in ~/.config/nvim/lua/plugin-config/
-- NOTE: Use `gf` to open the config file of the plugin under the cursor

-- Automatically install and set up packer.nvim on any machine you clone your configuration to
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

--require('plugin-config.') -- 
local packer = require("packer")
packer.startup({
	function(use)
		-- Packer 可以管理自己本身
		use 'wbthomason/packer.nvim'
		-- ------------------------------- Plugins -------------------------------
		-- Colorschemes
		use 'cocopon/iceberg.vim'
		use 'shaunsingh/seoul256.nvim'
		use 'altercation/vim-colors-solarized'
		use 'catppuccin/nvim'
		use 'projekt0n/github-nvim-theme'
		use { -- File explorer
			"nvim-tree/nvim-tree.lua", requires = "nvim-tree/nvim-web-devicons", tag = 'nightly',
			-- TODO: ~/.config/nvim/lua/plugin-config/nvim-tree.lua
			config = function() require('plugin-config.nvim-tree') end,
		}
		use { -- Bufferline
			"akinsho/bufferline.nvim",
			requires = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
			-- TODO: ~/.config/nvim/lua/plugin-config/bufferline.lua
			config = function() require('plugin-config.bufferline') end,
		}
		use { -- Statusline
			"nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons" },
			-- TODO: ~/.config/nvim/lua/plugin-config/lualine.lua
			config = function() require('plugin-config.lualine') end
		}
		use("arkav/lualine-lsp-progress")
		use { -- Highlight
			"nvim-treesitter/nvim-treesitter", run = ":TSUpdate",
			-- TODO: ~/.config/nvim/lua/plugin-config/nvim-treesitter.lua
			config = function() require('plugin-config.nvim-treesitter') end
		}
		use({ "p00f/nvim-ts-rainbow", requires = "nvim-treesitter/nvim-treesitter" })

		------------------------- LSP -------------------------
		-- Manage LSP / DAP / Formatter / Linter. Don't change the order.
		-- TODO: ~/.config/nvim/lua/lsp/setup.lua
		use {
			"williamboman/mason.nvim", -- LSP Installer
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig", -- LSP Config
		}
		-- Completion Engine
		-- TODO: ~/.config/nvim/lua/cmp/setup.lua
		use("hrsh7th/nvim-cmp")
		-- Snippet Engine
		use("L3MON4D3/LuaSnip")
		use("saadparwaiz1/cmp_luasnip")
    -- Completion Source
    use("hrsh7th/cmp-vsnip")
    use("hrsh7th/cmp-nvim-lsp") -- { name = nvim_lsp }
    use("hrsh7th/cmp-buffer") -- { name = 'buffer' },
    use("hrsh7th/cmp-path") -- { name = 'path' }
    use("hrsh7th/cmp-cmdline") -- { name = 'cmdline' }
    use("hrsh7th/cmp-nvim-lsp-signature-help") -- { name = 'nvim_lsp_signature_help' }
		-- Common Language Snippets
		use("rafamadriz/friendly-snippets")
		-- UI 
		use("onsails/lspkind-nvim")
    use("tami5/lspsaga.nvim")
		-- Code Formatter
		use("mhartington/formatter.nvim")
    use({ "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" })
		-- Misc
		use { -- Colorizer
			"norcalli/nvim-colorizer.lua",
			-- TODO: ~/.config/nvim/lua/plugin-config/colorizer.lua
			config = function() require('plugin-config.colorizer') end
		}
		use 'github/copilot.vim'
		use 'tpope/vim-sensible'
		use { -- A better user experience for interacting with and manipulating Vim marks.
			'chentoast/marks.nvim',
			-- TODO: ~/.config/nvim/lua/plugin-config/marks.lua
			config = function() require('plugin-config.marks') end
		}
		use { -- If not under neovide, use beacon.nvim to highlight cursor
			'DanilaMihailov/beacon.nvim',
			config = function() require('plugin-config.beacon') end
		}
		--use {"petertriho/nvim-scrollbar", config=function() require("scrollbar").setup() end}
		use("dstein64/nvim-scrollview")

		-- Automatically set up your configuration after cloning packer.nvim
  	-- Put this at the end after all plugins
  	if packer_bootstrap then
  	  require('packer').sync()
  	end
	end,
	config = {
		max_jobs = 16, -- 16个并发任务
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
		},
	},
})

-- Load plugins by require
--if vim.g.neovide==nil then -- If under neovide, don't load beacon.nvim
--	vim.cmd [[packadd beacon.nvim]]
--end


-- 每次保存 plugins.lua 自动安装插件
pcall(
	vim.cmd,
	[[
    augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
  ]]
)
