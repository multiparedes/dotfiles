# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="half-life"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias webstorm="/usr/local/bin/WebStorm-243.26053.12/bin/webstorm"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

alias taptapVPN="'/home/marti/.vpn/venv/bin/python' '/home/marti/.vpn/connectVPN-ubuntu.py'"
alias cvpn="openvpn3 session-start --config /home/marti/.vpn/config1.ovpn 2> /dev/null"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# Run a command in a loop: Enter to rerun, Ctrl+C to close the pane
runloop() {
  while true; do
    "$@"
    # Scroll down to make sure the exit prompt is visible (process may have moved cursor)
    printf '\n  [process exited] — press Enter to rerun, Ctrl+C to close\n'
    read || return
  done
}

# Launch kitty layouts using the current pane as the first split.
# Falls back to a new window if called outside kitty.

tesela() {
  if [[ -z "$KITTY_WINDOW_ID" ]]; then kitty --session ~/.config/kitty/sessions/tesela.session; return; fi
  kitten @ launch --location vsplit --cwd ~/Proyectos/tesela-platform-engine zsh -i -c 'runloop npm run dev -- --port 5174'
  kitten @ launch --location hsplit --cwd ~/Proyectos/userpanel_front zsh -i -c 'source ~/.nvm/nvm.sh && runloop npm run dev -- --port 5173'
  cd ~/Proyectos/tesela-userpanel
  clear
  runloop ./run flask
}

dashboard() {
  if [[ -z "$KITTY_WINDOW_ID" ]]; then kitty --session ~/.config/kitty/sessions/dashboard.session; return; fi
  kitten @ launch --location vsplit --cwd ~/Proyectos/userpanel_front zsh -i -c 'source ~/.nvm/nvm.sh && runloop nr dev --port 5173'
  kitten @ launch --location hsplit --cwd ~/Proyectos zsh
  cd ~/Proyectos/tesela-userpanel
  runloop ./run flask
}

engine() {
  if [[ -z "$KITTY_WINDOW_ID" ]]; then kitty --session ~/.config/kitty/sessions/engine.session; return; fi
  kitten @ launch --location vsplit --cwd ~/Proyectos/tesela-platform-engine zsh -i -c 'source ~/.nvm/nvm.sh && runloop npm run dev -- --port 5174'
  kitten @ launch --location hsplit --cwd ~/Proyectos zsh
  cd ~/Proyectos/tesela-userpanel
  runloop ./run flask
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--layout=default --preview="fzf-preview.sh {}"'
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PYTHONBREAKPOINT="ipdb.set_trace"

alias pycharm="/usr/local/bin/pycharm-2025.1.1/bin/pycharm"

alias co="git switch"
alias gs='git status'
alias pd='deactivate'

alias ls="lsd --group-dirs first"
alias ipy="ipython3"
alias bat="bat --theme OneHalfDark"
alias da="deactivate"
alias cosmos="cd /home/marti/Proyectos/tesela-cosmos-playground && nr cosmos"
alias vim="nvim"
alias nv="nvim ."

# Function aliases
sm() {
  if [ -n "$1" ]; then
    echo -e "\033[1;34m🔐 Fetching secret:\033[0m $1"
    secret=$(aws secretsmanager get-secret-value --secret-id "$1" 2>/dev/null)

    if [ $? -eq 0 ]; then
      secret_string=$(echo "$secret" | jq -r '.SecretString')
      echo "$secret_string" | jq -C
    else
      echo -e "\033[1;31m✖ Failed to retrieve secret.\033[0m"
    fi
  else
    echo -e "\033[1;33m⚠ Missing secret id, usage:\033[0m sm <secret-id>"
  fi
}

pa() {
  eval $(poetry env activate)
}

bkill() {
  kill -9 $(ps aux | grep '[u]vicorn' | awk '{print $2}')
}

delete-branch() {
  if [ -z "$1" ]; then
    echo "Usage: delete-branch <branchname> [remote]"
    return 1
  fi

  branch="$1"
  remote="${2:-origin}"  # Default to 'origin' if not specified

  echo "Deleting remote branch '$branch' from '$remote'..."
  git push "$remote" -d "$branch"

  echo "Deleting local branch '$branch'..."
  git branch -d "$branch"
}

gddb () {
  notify-send 'o_o'
  aws rds generate-db-auth-token --hostname tap-dev-useast-postgres-demography.cnmxfcili0i5.us-east-1.rds.amazonaws.com --port 5432 --username marti.paredes \
    | tr -d '\n' \
    | xclip -selection clipboard
  notify-send ':D'
}

gdpdb () {
  notify-send 'o_o'
  aws rds generate-db-auth-token --hostname tap-pro-useast-postgres-demography.cnmxfcili0i5.us-east-1.rds.amazonaws.com --port 5432 --username marti.paredes \
    | tr -d '\n' \
    | xclip -selection clipboard
  notify-send ':D'
}

# bun completions
[ -s "/home/marti/.bun/_bun" ] && source "/home/marti/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias rm='trash'
alias wifi='nmtui'

# opencode
export PATH=/home/marti/.opencode/bin:$PATH
alias oc='opencode'

alias svim="sudo $(which nvim)"

alias od="cd /home/marti/AI/open-design && pnpm tools-dev"
alias opendesign="cd /home/marti/AI/open-design && pnpm tools-dev"

admin() {
  if [[ -z "$KITTY_WINDOW_ID" ]]; then kitty --session ~/.config/kitty/sessions/admin.session; return; fi
  kitten @ launch --location vsplit --cwd ~/Proyectos/tesela-admin zsh -i -c 'source ~/.nvm/nvm.sh && runloop nr dev'
  kitten @ launch --location hsplit --cwd ~/Proyectos zsh
  cd ~/Proyectos/tesela-admin-api
  runloop ./run flask
}
