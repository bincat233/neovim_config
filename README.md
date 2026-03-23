# Neovim Config

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的个人配置，使用 `lazy.nvim` 管理插件。

## Requirements

- Neovim >= 0.9
- Git
- Nerd Font（建议）

## Quick Start

```bash
git clone <your-repo> ~/.config/nvim
nvim
```

首次启动会自动安装 `lazy.nvim` 与插件。

## Project Structure

```text
.
├── init.lua                  # 入口：终端变量相关 autocmd + 启动 lazy
├── lua/config/
│   ├── lazy.lua              # lazy.nvim 引导 + LazyVim extras + plugins import
│   ├── options.lua           # 基础选项
│   ├── keymaps.lua           # 键位映射
│   └── autocmds.lua          # 自动命令
├── lua/plugins/              # 插件配置（按功能拆分）
├── lua/local/
│   ├── color.lua             # 颜色工具
│   ├── debug.lua             # 调试工具
│   └── utils.lua             # 通用工具（含平台检测 get_env）
├── after/colors/pywal16.lua  # 颜色主题后置覆盖
└── asciiart/                 # Dashboard 资源
```

## Conventions

- `lua/local/` 固定仅保留 3 个文件：`color.lua`、`debug.lua`、`utils.lua`。
- 不在 `utils.lua` 中聚合或 merge `color/debug`；按需直接 `require("local.color")` / `require("local.debug")`。
- 新增插件优先放在 `lua/plugins/` 下独立文件，保持单文件单职责。

## Colorscheme Strategy

`lua/plugins/colorscheme.lua` 使用 `require("local.utils").get_env()` 做平台判断：

- `linux_console` -> `solarized` + `termguicolors=false`
- `windows` / `macos` -> `github_dark`
- Linux GUI -> `pywal16` + `darkman.nvim`
- 当前目录命中 `seoul256` 项目名时，切换到 `seoul256`

## Daily Commands

- `:Lazy`：查看插件状态
- `:Lazy sync`：同步插件
- `:checkhealth`：环境健康检查
- `:source $HOME/.config/nvim/init.lua`：重载入口文件

## Notes

- `lazy-lock.json` 已启用并建议纳入版本控制。
- 若修改主题或 UI 配置，建议同时检查 `after/colors/pywal16.lua` 的覆盖效果。
