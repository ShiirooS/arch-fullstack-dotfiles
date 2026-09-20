[[ $- != *i* ]] && return

HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"
setopt appendhistory sharehistory histignoredups interactivecomments

autoload -Uz compinit
compinit

bindkey -e

export EDITOR=nvim
export VISUAL=nvim
export BAT_THEME="base16"

alias ls='eza --icons --color=always'
alias ll='eza --icons --color=always -l'
alias la='eza --icons --color=always -la'
alias tree='eza --icons --tree --level=2'
alias cat='bat --paging=never'
alias vim='nvim'
alias lg='lazygit'
alias dc='docker compose'

mkvenv() {
  local name="${1:-.venv}"
  python -m venv "$name" && source "$name/bin/activate"
}

venv() {
  source "${1:-.venv}/bin/activate"
}

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi
