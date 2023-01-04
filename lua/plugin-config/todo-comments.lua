-- Configuration example:
-- https://github.com/folke/todo-comments.nvim#%EF%B8%8F-configuration
-- Usage:
-- https://github.com/folke/todo-comments.nvim#-usage
require("todo-comments").setup {
	keywords= {
		-- Overwrite the default emoji icon to nerd font icon
		TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
	},
	search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
}

-- Path: ~/.config/nvim/lua/keybindings.lua
local keys = require("keybindings")

keys.todo_comments_keys_setup()
