#!/usr/bin/env bash
# Sin argumentos: JSON para el modulo custom/updates de waybar.
# "run": abre una terminal con `update` (todo: sistema, AUR, nvim, tmux, firmware).

if [[ "${1:-}" == "run" ]]; then
  exec ghostty -e zsh -c 'update; read -sk1 "?Presiona una tecla para cerrar."'
fi

official=$(checkupdates 2>/dev/null | wc -l)
aur=$(yay -Qua 2>/dev/null | wc -l)
total=$((official + aur))

if (( total == 0 )); then
  echo '{"text": "", "tooltip": "Sistema al dia", "class": "updated"}'
else
  printf '{"text": "󰚰 %d", "tooltip": "Oficiales: %d\\nAUR: %d\\nClick para actualizar", "class": "pending"}\n' \
    "$total" "$official" "$aur"
fi
