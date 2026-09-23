# zsh lee este archivo siempre (login, interactivo y scripts).
typeset -U path
path=("$HOME/.local/bin" $path)
export PATH
