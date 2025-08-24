# ============================
# Zinit plugin manager
# ============================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light agkozak/zsh-z
zinit snippet OMZP::git
zinit light trapd00r/LS_COLORS

# Prompt (Powerlevel10k)
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ============================
# Completion
# ============================
autoload -Uz compinit
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# ============================
# Fastfetch (only once at login)
# ============================
if [[ $- == *i* && -x "$(command -v fastfetch)" && -z "$FASTFETCH_SHOWN" ]]; then
  export FASTFETCH_SHOWN=1
  fastfetch
fi

# ============================
# Podman ⇢ Docker Compatibility
# ============================
# Podman as Docker backend
export DOCKER_HOST="unix:///run/user/$UID/podman/podman.sock"

# Ensure podman.socket is running
if command -v podman &>/dev/null; then
  systemctl --user start podman.socket 2>/dev/null
fi

# docker → podman wrapper
if command -v podman &>/dev/null && ! command -v docker &>/dev/null; then
  docker() { podman "$@"; }
  compdef docker=podman
fi

# docker-compose → podman-compose wrapper
if command -v podman-compose &>/dev/null && ! command -v docker-compose &>/dev/null; then
  docker-compose() { podman-compose "$@"; }
  compdef docker-compose=podman-compose
fi

# lazydocker wrapper
alias lazydocker='DOCKER_HOST=$DOCKER_HOST lazydocker'

# Toggle between Podman & Docker
dockerswap() {
  if [[ "$DOCKER_HOST" == "unix:///run/user/$UID/podman/podman.sock" ]]; then
    unset DOCKER_HOST
    echo "🔄 Switched to real Docker"
  else
    export DOCKER_HOST="unix:///run/user/$UID/podman/podman.sock"
    echo "🔄 Switched to Podman (Docker API mode)"
  fi
}

# Cleanup helper
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '

# ============================
# History
# ============================
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=20000
export HISTTIMEFORMAT="%F %T"
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE APPEND_HISTORY EXTENDED_HISTORY

# ============================
# Terminal settings
# ============================
setopt NO_BEEP
stty -ixon   # disable Ctrl+S freeze

# ============================
# XDG Base Dirs
# ============================
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# ============================
# PATH
# ============================
path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  /var/lib/flatpak/exports/bin
  $HOME/.local/share/flatpak/exports/bin
  $path
)
export PATH

# ============================
# Editor
# ============================
export EDITOR=nvim
export VISUAL=nvim
alias vim='nvim'

# ============================
# Aliases & Functions
# ============================
# Safer defaults
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='trash -v'     # needs trash-cli
alias mkdir='mkdir -pv'

alias cls='clear'
alias ezrc="$EDITOR ~/.zshrc"
alias szrc="source ~/.zshrc"

# Git shortcuts
if command -v git &>/dev/null; then
  alias g='git'
  alias gst='git status'
  alias gl='git log --oneline --graph --decorate'
  alias gp='git pull'
  alias gco='git checkout'
fi

# Better ls (use eza if installed)
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons'
  alias la='eza -a'
  alias ll='eza -lh'
  alias lla='eza -lah'
  alias lt='eza -snew -l'
else
  alias ls='ls --color=auto -Fh'
  alias la='ls -Alh'
  alias ll='ls -lh'
  alias lla='ls -Alh'
fi

# Manpage colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Extraction helper
extract() {
  for archive in "$@"; do
    [[ -f $archive ]] || { echo "Not a file: $archive"; continue }
    case $archive in
      *.tar.bz2) tar xvjf "$archive" ;;
      *.tar.gz)  tar xvzf "$archive" ;;
      *.bz2)     bunzip2 "$archive" ;;
      *.rar)     unrar x "$archive" ;;
      *.gz)      gunzip "$archive" ;;
      *.tar)     tar xvf "$archive" ;;
      *.tbz2)    tar xvjf "$archive" ;;
      *.tgz)     tar xvzf "$archive" ;;
      *.zip)     unzip "$archive" ;;
      *.7z)      7z x "$archive" ;;
      *) echo "Don't know how to extract '$archive'" ;;
    esac
  done
}

# Networking
alias openports='ss -tulnp'
whatismyip() {
  echo "Internal: $(ip -4 addr show scope global | awk '/inet/{print $2}' | cut -d/ -f1)"
  echo "External: $(curl -s ifconfig.me)"
}

# Dir helpers
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
function chpwd() { ls }  # auto-ls on cd

# ============================
# Keybindings
# ============================
# --- Keybindings (Zsh way) ---
# Bind Ctrl+f to run `zi`
if [[ $- == *i* ]]; then
  bindkey -s '^F' "zi\n"
fi

# ============================
# Plugins: Zoxide + Direnv
# ============================
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# ============================
# Autostart X on tty1
# ============================
if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
  exec startx
fi
