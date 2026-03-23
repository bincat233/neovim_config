return {
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaRead", "SudaWrite" },
    init = function()
      vim.g.suda_smart_edit = 1
    end,
  },
  {
    "anurag3301/nvim-platformio.lua",
    cond = function()
      local platformio_root = (vim.fn.filereadable("platformio.ini") == 1) and vim.fn.getcwd() or nil

      if platformio_root then
        vim.g.platformioRootDir = platformio_root
      elseif (vim.uv or vim.loop).fs_stat(vim.fn.stdpath("data") .. "/lazy/nvim-platformio.lua") == nil then
        vim.g.platformioRootDir = vim.fn.getcwd()
      else
        vim.api.nvim_create_user_command("Pioinit", function()
          vim.api.nvim_create_autocmd("User", {
            pattern = { "LazyRestore", "LazyLoad" },
            once = true,
            callback = function(args)
              if args.match == "LazyRestore" then
                require("lazy").load({ plugins = { "nvim-platformio.lua" } })
              elseif args.match == "LazyLoad" then
                local pio_install_status = require("platformio.utils").pio_install_check()
                if not pio_install_status then
                  return
                end
                vim.notify("PlatformIO loaded", vim.log.levels.INFO, { title = "PlatformIO" })
                require("platformio").setup(vim.g.pioConfig)
                vim.cmd("Pioinit")
              end
            end,
          })
          vim.g.platformioRootDir = vim.fn.getcwd()
          require("lazy").restore({ plugins = { "nvim-platformio.lua" }, show = false })
        end, {})
      end

      return vim.g.platformioRootDir ~= nil
    end,
    dependencies = {
      { "akinsho/nvim-toggleterm.lua" },
      { "nvim-telescope/telescope.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
  },
}
