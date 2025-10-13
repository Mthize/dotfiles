# 🌐 Thapelo's Web Dev Neovim Setup

Welcome to my **Neovim configuration**, crafted for modern **web development**. Whether you're working in **HTML, CSS, JavaScript, TypeScript, React, Tailwind**, or building full-stack apps — this setup is fast, beautiful, and highly productive.

> ⚡ Blazing fast | 🧠 LSP powered | 🎈 Modern UI | 🧹 Plugin-rich | 🌍 Web Dev Ready

### Startup screen
![Neovim dashboard](screenshots/swappy-20250707-212537.png)

### LSP + File Explorer in action
![Neovim LSP config](screenshots/swappy-20250707-212703.png)
---

## ✨ Key Features

🎨 **Aesthetic UI**

* Custom dashboard + smooth transitions
* `lualine` + `bufferline` + Nerd Fonts
* Treesitter-powered highlighting

🧠 **Smart Web Dev Tools**

* Language Server Protocol (LSP) for:

  * HTML, CSS, JS, TS, JSON, Markdown, Vue, React
* Autocomplete with `nvim-cmp`
* Formatter + linter integration (Prettier, ESLint)

🔎 **File & Code Navigation**

* `telescope.nvim` for fuzzy finding
* `nvim-tree.lua` for file explorer
* `trouble.nvim` for quick diagnostics

⚙️ **Productivity Plugins**

* Git tools (`gitsigns.nvim`, `lazygit`)
* Commenting, autopairs, surround
* Live TailwindCSS color highlighting
* Code snippets and emmet support

🌍 **Frontend Friendly**

* Tailwind IntelliSense, CSS color preview
* React/JSX highlighting
* Node/Express and TypeScript support

---

## 📁 Folder Structure

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── core/       → Base settings & mappings
│   ├── plugins/    → Plugin configs
│   ├── lsp/        → Language servers
│   └── utils/      → Helper functions
└── screenshots/    → README screenshots
```

---

## 🧰 Prerequisites

Make sure you have:

* Neovim `>= 0.9`
* `node`, `npm`, or `yarn` installed
* `ripgrep` and `fd` for fuzzy finding
* Patched Nerd Font (like FiraCode Nerd)

---

## 🛠️ Installation

```bash
git clone https://github.com/Mthize/neovim-dotfiles ~/.config/nvim
```

Then open Neovim and let `lazy.nvim` handle the rest.

---

## 💡 Shortcuts

| Action           | Key          |
| ---------------- | ------------ |
| Fuzzy Find Files | `<leader>ff` |
| Live Grep        | `<leader>fg` |
| Toggle Tree      | `<leader>e`  |
| Open Terminal    | `<leader>tt` |
| Format Code      | `<leader>fm` |
| Toggle Comments  | `gc`         |
| Go to Definition | `gd`         |

---

## 📸 Screenshots

| Dashboard                            | JS/TS LSP                        | Tailwind Preview                        |
| ------------------------------------ | -------------------------------- | --------------------------------------- |
| ![dash](./screenshots/dashboard.png) | ![lsp](./screenshots/lsp-ts.png) | ![tailwind](./screenshots/tailwind.png) |


---

## ✨ Inspired By

* [LazyVim](https://github.com/LazyVim/LazyVim)
* [NvChad](https://github.com/NvChad/NvChad)
* [AstroNvim](https://github.com/AstroNvim/AstroNvim)

---

## 👋 Connect with Me

I’m Thapelo — Web Dev + Backend Dev + Tooling Fanatic.

* 🔗 [LinkedIn](https://linkedin.com/in/thapelomthize)
* 🌐 [Portfolio](https://github.com/Mthize)
* 📬 Open to feedback or collab!

---

> "Code like a hacker, build like a designer." — Thapelo

 
