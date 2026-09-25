# Basado en el .zshrc de ViegPhunt/Dotfiles, con los plugins desde pacman/AUR
# en vez de zinit (nada se descarga al abrir la terminal).
[[ $- != *i* ]] && return

# ─── Historial ───────────────────────────────────────────────────
HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"
setopt appendhistory sharehistory histignoredups interactivecomments

bindkey -e

export EDITOR=nvim
export VISUAL=nvim

# ─── FZF (tema Catppuccin Mocha) ─────────────────────────────────
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#313244,label:#CDD6F4"

# Atajos de fzf (Ctrl+R historial, Ctrl+T archivos). Antes de fzf-tab: si no,
# fzf --zsh le quita la tecla Tab.
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# ─── Autocompletado ──────────────────────────────────────────────
# zsh-completions (pacman) instala en site-functions, que ya esta en fpath.
autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{A-Za-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# fzf-tab (AUR): menu de completado con fzf y vista previa. Va despues de
# compinit y antes de autosuggestions/syntax-highlighting.
for f in /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh \
         /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh; do
  [[ -r $f ]] && { source "$f"; break; }
done
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-flags --height=17
zstyle ':fzf-tab:complete:*' fzf-preview '
if [ -d "$realpath" ]; then
    eza --icons --tree --level=2 --color=always "$realpath"
elif [ -f "$realpath" ]; then
    bat -n --color=always --line-range :500 "$realpath"
fi
'

# ─── Alias ───────────────────────────────────────────────────────
export BAT_THEME="base16"
alias ls='eza --icons --color=always'
alias ll='eza --icons --color=always -l'
alias la='eza --icons --color=always -a'
alias lla='eza --icons --color=always -la'
alias lt='eza --icons --color=always -a --tree --level=1'
alias tree='eza --icons --tree --level=2'
alias cat='bat --paging=never'
alias grep='grep --color=auto'
alias vim='nvim'
alias lg='lazygit'
alias lzg='lazygit'
alias lzd='lazydocker'
alias dc='docker compose'

# ─── Python venv ─────────────────────────────────────────────────
_activate_venv() {
  if [[ -f "$1/bin/activate" ]]; then
    source "$1/bin/activate"
  else
    echo "No hay entorno virtual en '$1'."
  fi
}

mkvenv() {
  local name="${1:-.venv}"
  [[ -d "$name" ]] || python -m venv "$name" || return 1
  _activate_venv "$name"
}

venv() { _activate_venv "${1:-.venv}"; }

# ─── Herramientas ────────────────────────────────────────────────
eval "$(zoxide init zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Prompt de ViegPhunt (oh-my-posh). Si no esta, cae a starship.
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/viet.omp.json)"
elif command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Pokemon al abrir la terminal (pokemon-colorscripts-git, AUR).
command -v pokemon-colorscripts >/dev/null 2>&1 && pokemon-colorscripts --no-title -s -r

[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Tiene que ir ultimo: envuelve los widgets de zle definidos antes.
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
