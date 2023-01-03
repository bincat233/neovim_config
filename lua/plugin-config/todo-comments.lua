-- Configuration example:
-- https://github.com/folke/todo-comments.nvim#%EF%B8%8F-configuration
require("todo-comments").setup {
	keywords= {
		-- Overwrite the default emoji icon to nerd font icon
		TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
	},
}

local keys = require("keybindings")

keys.todo_comments_keys_setup()
