# nvim-lite
iA minimal neovim configuration for Elixir development

Requires NeoVim 0.12 or later

```bash
```bash`
mkdir -p ~/.config/nvim iand clone this repo

## Got original content from:

radleylewis/nvim-lite
```

## Dependencies

NeoVim `0.12` (available in the AUR)
```bash
paru -S neovim-git
```

Treesitter `0.26.5` (install using `cargo`)
```bash
cargo install --locked tree-sitter-cli
```

`golang` (for `efm-langserver`)
```bash
sudo pacman -S go
```

LuaSnip dependencies:
```bash
sudo pacman -S lua-jsregexp
```

Other general dependencies:
```bash
sudo pacman -S git ripgrep fzf fd
```
