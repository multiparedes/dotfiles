#!/bin/bash
set -e

DOTFILES_DIR="$HOME/multiparedes/.dotfiles"

echo "==> Installing dependencies..."
sudo apt update -qq
sudo apt install -y zsh stow curl git

echo "==> Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "==> Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ] && \
  git clone https://github.com/jeffreytse/zsh-vi-mode "$ZSH_CUSTOM/plugins/zsh-vi-mode"

echo "==> Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

echo "==> Installing pyenv..."
if [ ! -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
fi

echo "==> Setting up SSH for personal GitHub..."
if [ ! -f "$HOME/.ssh/github_personal" ]; then
  ssh-keygen -t ed25519 -C "martiparedes19@gmail.com" -f "$HOME/.ssh/github_personal" -N ""
  echo ""
  echo "Add this public key to github.com/settings/ssh:"
  echo ""
  cat "$HOME/.ssh/github_personal.pub"
  echo ""
  read -p "Press enter once key is added to GitHub..."
fi

if ! grep -q "github-personal" "$HOME/.ssh/config" 2>/dev/null; then
  cat >> "$HOME/.ssh/config" <<EOF

Host github-personal
  HostName github.com
  User git
  IdentityFile $HOME/.ssh/github_personal
  AddKeysToAgent yes
EOF
fi

ssh-keyscan -H github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null

echo "==> Cloning dotfiles..."
if [ ! -d "$DOTFILES_DIR" ]; then
  mkdir -p "$HOME/multiparedes"
  git clone git@github-personal:multiparedes/.dotfiles.git "$DOTFILES_DIR"
fi

echo "==> Removing existing configs..."
rm -f "$HOME/.zshrc" "$HOME/.gitconfig" "$HOME/.nanorc" "$HOME/.p10k.zsh"
rm -rf "$HOME/.config/kitty" "$HOME/.config/nvim"

echo "==> Setting up git identity..."
if [ ! -f "$HOME/.gitconfig-local" ]; then
  read -p "Git name: " git_name
  read -p "Git email: " git_email
  cat > "$HOME/.gitconfig-local" <<EOF
[user]
	name = $git_name
	email = $git_email
EOF
fi

echo "==> Stowing packages..."
cd "$DOTFILES_DIR"
stow --target "$HOME" kitty nano zsh git nvim

echo "==> Changing default shell to zsh..."
chsh -s "$(which zsh)"

echo ""
echo "Done. Restart terminal."
