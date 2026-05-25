# .dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
.dotfiles/
├── git/       → ~/.gitconfig
├── zsh/       → ~/.zshrc, ~/.p10k.zsh
├── kitty/     → ~/.config/kitty/
├── nvim/      → ~/.config/nvim/
└── nano/      → ~/.nanorc
```

## Fresh install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/multiparedes/.dotfiles/master/install.sh)
```

Or manually:

```bash
# 1. Clone
mkdir -p ~/multiparedes
git clone git@github-personal:multiparedes/.dotfiles.git ~/multiparedes/.dotfiles

# 2. Stow
cd ~/multiparedes/.dotfiles
stow --target ~ kitty nano zsh git nvim
```

## Adding a new package

```bash
mkdir -p ~/multiparedes/.dotfiles/foo
mv ~/.foorc ~/multiparedes/.dotfiles/foo/.foorc
cd ~/multiparedes/.dotfiles && stow --target ~ foo
```
