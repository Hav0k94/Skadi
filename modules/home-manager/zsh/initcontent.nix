{ config, lib, starshipTheme,... }:

let
  cfg = config.myModules.zsh;
in

{
  config = lib.mkIf cfg.enable {
    programs.zsh.initContent = ''
      # Ansible
      export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3
      #ls
      ls() { eza -al --color=always --group-directories-first --icons "$@" }
      la() { eza -a --color=always --group-directories-first --icons "$@" }
      ll() { eza -l --color=always --group-directories-first --icons "$@" }
      lt() { eza -aT --color=always --group-directories-first --icons "$@" }
      ld() { eza -ald --color=always --group-directories-first --icons .* "$@" }
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[3;5~' kill-word
      bindkey '^H' backward-kill-word
      bindkey '^[[1;3C' forward-word    # Alt+Droite
      bindkey '^[[1;3D' backward-word   # Alt+Gauche
      bindkey '^[[1;2C' forward-word    # Shift+Droite
      bindkey '^[[1;2D' backward-word   # Shift+Gauche
      WORDCHARS=''${WORDCHARS/\//}
      compdef _eza ls la ll lt ld
      # Lancer fastfetch au login
      if command -v fastfetch &> /dev/null; then
        fastfetch
      fi
      ${lib.optionalString (starshipTheme == "strangership") ''
        if [ -f ~/.config/zsh/demogorgonascii.txt ]; then
          echo -e "\e[38;2;123;47;190m$(cat ~/.config/zsh/demogorgonascii.txt)\e[0m"
        fi
        sleep 1
        if [ -f ~/.config/zsh/strangernix.txt ]; then
          echo -e "\e[38;2;204;0;0m$(cat ~/.config/zsh/strangernix.txt)\e[0m"
        fi
      ''}
    '';
  };
}
