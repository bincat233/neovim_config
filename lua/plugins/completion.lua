return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      utils.obj_dump(opts)
      local cmp = require("cmp")
      local function conferm_selection(fallback)
        if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
          LazyVim.create_undo()
          if cmp.confirm(opts) then
            return
          end
        end
        return fallback()
      end
      opts.preselect = cmp.PreselectMode.None -- Don't preselect first item
      opts.completion = { completeopt = "menu,menuone,noselect" } -- Don't preselect first item
      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        -- Remove default <CR> mapping
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Don't select first item
        ["<C-h>"] = cmp.mapping.abort(),
        ["<C-c>"] = cmp.mapping.abort(),
        ["<C-l>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true, -- Perselect first item
        }),
        -- Allow scrolling in documentation windows
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-8), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(8), { "i", "c" }),
        -- Navigation
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous
        ["<C-j>"] = cmp.mapping.select_next_item(), -- Next
      })
      --obj_dump(opts.completion)
    end,
  }, -- nvim-cmp (Completion)
}
