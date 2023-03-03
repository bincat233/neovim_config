local status, telescope = pcall(require, "telescope")
if not status then
	vim.notify("Telescope not found")
	return
end
local telescope_keys = {

	enable = true,

	find_files = "<C-p>",
	live_grep = "<C-f>",

	-- 上下移动
	move_selection_next = "<C-j>",
	move_selection_previous = "<C-k>",
	-- move_selection_next = "<C-n>",
	-- move_selection_previous = "<C-p>",
	-- 历史记录
	cycle_history_next = "<Down>",
	cycle_history_prev = "<Up>",
	-- 关闭窗口
	-- close = "<C-c>",
	close = "<esc>",
	-- 预览窗口上下滚动
	preview_scrolling_up = "<C-u>",
	preview_scrolling_down = "<C-d>",
}

-- local actions = require("telescope.actions")
telescope.setup({
	defaults = {
		-- 打开弹窗后进入的初始模式，默认为 insert，也可以是 normal
		initial_mode = "insert",
		-- vertical , center , cursor
		layout_strategy = "horizontal",
		-- 窗口内快捷键
		--

		mappings = {
			i = {
				-- 上下移动
				[telescope_keys.move_selection_next] = "move_selection_next",
				[telescope_keys.move_selection_previous] = "move_selection_previous",
				-- 历史记录
				[telescope_keys.cycle_history_next] = "cycle_history_next",
				[telescope_keys.cycle_history_prev] = "cycle_history_prev",
				-- 关闭窗口
				-- ["<esc>"] = actions.close,
				[telescope_keys.close] = "close",
				-- 预览窗口上下滚动
				[telescope_keys.preview_scrolling_up] = "preview_scrolling_up",
				[telescope_keys.preview_scrolling_down] = "preview_scrolling_down",
			},
		},
	},
	pickers = {
		find_files = {
			-- theme = "dropdown", -- 可选参数： dropdown, cursor, ivy
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				-- even more opts
				initial_mode = "normal",
			}),
		},
	},
})

keymap("n", telescope_keys.find_files, ":Telescope find_files<CR>")
keymap("n", telescope_keys.live_grep, ":Telescope live_grep<CR>")

pcall(telescope.load_extension, "env")
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
pcall(telescope.load_extension, "ui-select")
