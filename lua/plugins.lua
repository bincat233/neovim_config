-- TODO: Will switch to lazy.nvim
-- Plugins settings
--

-- Plugins stored in ~/.local/share/nvim/site/pack/packer/start
-- Use :PackerSync to install/update plugins

-- And most plugins has a config script stored in ~/.config/nvim/lua/plugin-config/
-- NOTE: Use `gf` to open the config file of the plugin under the cursor

-- Automatically install and set up packer.nvim on any machine you clone your configuration to
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
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
		use("wbthomason/packer.nvim")
		-- ------------------------------- Plugins -------------------------------
		-- Colorschemes and themes
		use("cocopon/iceberg.vim") -- My favorite colorscheme with best light theme
		--use("iceberg/iceberg.nvim") -- nvim port of iceberg.vim
		use("junegunn/seoul256.vim") -- Low contrast colorscheme
		--use("shaunsingh/seoul256.nvim") -- nvim port of seoul256, but without light theme
		use("folke/tokyonight.nvim") -- Has good support for treesitter
		use("altercation/vim-colors-solarized") -- Has good support under TTYs
		use("catppuccin/nvim")
		use("NLKNguyen/papercolor-theme")
		use("projekt0n/github-nvim-theme")
		use("folke/which-key.nvim")
		use({ -- File explorer
			"nvim-tree/nvim-tree.lua",
			requires = "nvim-tree/nvim-web-devicons",
			-- NOTE: ~/.config/nvim/lua/plugin-config/nvim-tree.lua
			config = function()
				require("plugin-config.nvim-tree")
			end,
		})
		use({ -- Bufferline
			"akinsho/bufferline.nvim",
			requires = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
			-- NOTE: ~/.config/nvim/lua/plugin-config/bufferline.lua
			config = function()
				require("plugin-config.bufferline")
			end,
		})
		use({ -- Statusline
			"nvim-lualine/lualine.nvim",
			requires = { "nvim-tree/nvim-web-devicons" },
			-- NOTE: ~/.config/nvim/lua/plugin-config/lualine.lua
			config = function()
				require("plugin-config.lualine")
			end,
		})
		use("arkav/lualine-lsp-progress") -- LSP progress for lualine
		---------------- Highlight (treesitter) ----------------
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			-- NOTE: ~/.config/nvim/lua/plugin-config/nvim-treesitter.lua
			config = function()
				require("plugin-config.nvim-treesitter")
			end,
		}) -- Treesitter
		use({ "p00f/nvim-ts-rainbow", requires = "nvim-treesitter/nvim-treesitter" }) -- Rainbow parentheses
		use({
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("plugin-config.todo-comments")
			end,
		}) -- Highlight TODO/FIXME/BUG/NOTE/...

		use({
			"RRethy/nvim-treesitter-endwise",
			config = function()
				require("plugin-config.nvim-treesitter-endwise")
			end,
		})
		------------------------- LSP -------------------------
		-- Manage LSP / DAP / Formatter / Linter. Don't change the order.
		-- NOTE: ~/.config/nvim/lua/lsp/setup.lua
		use({
			"junnplus/lsp-setup.nvim", -- Simple wrapper for nvim-lspconfig
			"williamboman/mason.nvim", -- LSP Installer
			"williamboman/mason-lspconfig.nvim", -- Bridge between lsp-setup.nvim and mason.nvim
			"neovim/nvim-lspconfig", -- LSP Config
		})
		-- 独立的 java LSP 客户端
		use("mfussenegger/nvim-jdtls")
		-- signature helper ( 函数参数提示 )
		use({ "ray-x/lsp_signature.nvim" }) -- better than nvim-lsp-signature-help
		-- Completion Engine
		-- NOTE: ~/.config/nvim/lua/cmp/setup.lua
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
		--use("hrsh7th/cmp-nvim-lsp-signature-help") -- { name = 'nvim_lsp_signature_help' }
		-- Common Language Snippets
		use("rafamadriz/friendly-snippets")
		-- UI
		use("onsails/lspkind-nvim")
		use({
			"nvimdev/lspsaga.nvim",
			-- NOTE: ~/.config/nvim/lua/lsp/lspsaga.lua
			config = function()
				require("lsp.lspsaga")
			end,
		})
		use({
			"stevearc/aerial.nvim",
			-- NOTE: ~/.config/nvim/lua/plugin-config/aerial.lua
			config = function()
				require("plugin-config.aerial")
			end,
		})
		-- Code Formatter
		--use("mhartington/formatter.nvim")
		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = "nvim-lua/plenary.nvim",
			-- NOTE: ~/.config/nvim/lua/lsp/null-ls.lua
		})

		----------------------------------- Misc -----------------------------------
		use("skywind3000/asyncrun.vim") -- Async Run Command
		--use({
		--	"terror/chatgpt.nvim",
		--	run = "pip3 install --user -r requirements.txt",
		--})
		--use("lilydjwg/fcitx.vim")
		use("h-hg/fcitx.nvim")
		use({
			"epwalsh/obsidian.nvim",
			require = "nvim-lua/plenary.nvim",
		})
		use({
			"ianding1/leetcode.vim",
			-- pacman -S python-keyring python-browser-cookie3 python-pynvim
			config = function()
				vim.g.leetcode_browser = "firefox"
				vim.g.leetcode_solution_filetype = "java"
				vim.g.leetcode_problemset = "all"
			end,
		})
		use({
			"uga-rosa/ccc.nvim",
			config = function()
				require("plugin-config.ccc")
			end,
		}) -- Colorizer / Color Picker
		use({
			"nvim-telescope/telescope.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("plugin-config.telescope")
			end,
		}) -- Fuzzy Finder 模糊搜索
		use({ -- Indent (缩进线)
			"lukas-reineke/indent-blankline.nvim",
			-- NOTE: ~/.config/nvim/lua/plugin-config/indent-blankline.lua
			config = function()
				require("plugin-config.indent-blankline")
			end,
		})
		use({
			"github/copilot.vim",
			config = function()
				local keys = require("keybindings")
				keys.copilot_keys_config()
				vim.cmd([[
					let g:copilot_filetypes = {
					\ '*': v:true,
					\ }
				]])
			end,
		})
		use("tpope/vim-sensible")
		use({ -- A better user experience for interacting with and manipulating Vim marks.
			"chentoast/marks.nvim",
			-- NOTE: ~/.config/nvim/lua/plugin-config/marks.lua
			config = function()
				require("plugin-config.marks")
			end,
		})
		use({ -- If not under neovide, use beacon.nvim to highlight cursor
			"DanilaMihailov/beacon.nvim",
			-- NOTE: ~/.config/nvim/lua/plugin-config/beacon.lua
			config = function()
				require("plugin-config.beacon")
			end,
		})

		use({
			"lewis6991/gitsigns.nvim",
			-- NOTE: ~/.config/nvim/lua/plugin-config/gitsigns.lua
			config = function()
				require("plugin-config.gitsigns")
			end,
			requires = {
				"nvim-lua/plenary.nvim",
			},
		})

		-- Text object
		use({
			"kylechui/nvim-surround",
			tag = "*", -- Use for stability; omit to use `main` branch for the latest features
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end,
		})

		---- Picture review in vim
		--use {
		--	'edluffy/hologram.nvim',
		--	config = function()
		--		require('hologram').setup{
		--		auto_display = true -- WIP automatic markdown image display, may be prone to breaking
		--		}
		--	end
		--}

		-- variables name highlight (变量名高亮) https://github.com/RRethy/vim-illuminate
		use({ "RRethy/vim-illuminate" })
		-- Scrollbar
		--use {"petertriho/nvim-scrollbar", config=function() require("scrollbar").setup() end}
		use("dstein64/nvim-scrollview")

		-- Auto pairs (自动补全括号)
		use({
			"windwp/nvim-autopairs",
			config = function()
				require("plugin-config.nvim-autopairs")
			end,
		})

		use({ "waycrate/swhkd-vim" })
		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if packer_bootstrap then
			require("packer").sync()
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
