# 🚀 Neovim Configuration

A modern Neovim configuration built on [LazyVim](https://github.com/LazyVim/LazyVim), a powerful and extensible Neovim setup.

## ✨ Features

- 🚀 Blazing fast startup time with lazy loading
- 🎨 Beautiful and modern UI with built-in themes
- ⚡ Optimized for both speed and productivity
- 🔌 Plugin management via Lazy.nvim
- 📦 Pre-configured with essential plugins
- 🛠️ Easy to customize and extend

## 📦 Prerequisites

- Neovim 0.9.0 or later
- Git
- A Nerd Font (recommended: [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads))

## 🚀 Installation

1. Backup your existing Neovim configuration (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/neovim-config ~/.config/nvim
   ```

3. Start Neovim and wait for the plugins to be installed:
   ```bash
   nvim
   ```

## 🛠️ Customization

- Add your own plugins in `lua/plugins/` directory
- Modify keymaps in `lua/config/keymaps.lua`
- Change theme in `lua/config/options.lua`

## 📚 Key Mappings

### Normal Mode
- `<leader>pv`: Open file explorer
- `<C-p>`: Fuzzy find files
- `<leader>ff`: Find files
- `<leader>fs`: Search in files
- `<leader>h`: Clear search highlights

### Insert Mode
- `jk`: Return to normal mode
- `kj`: Alternative to jk

## 🔌 Plugin Management

This configuration uses [Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management. To add new plugins:

1. Create or edit a file in `lua/plugins/`
2. Add your plugin configuration following the Lazy.nvim format
3. Run `:Lazy sync` to install/update plugins

## 📖 Documentation

For detailed documentation, please refer to:
- [LazyVim Documentation](https://lazyvim.github.io/)
- [Neovim Documentation](https://neovim.io/doc/)

## 🤝 Contributing

Feel free to submit issues and enhancement requests.

## 📜 License

This project is licensed under the MIT License.
