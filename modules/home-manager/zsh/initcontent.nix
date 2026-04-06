{ config, lib, starshipTheme,... }:

{
  config = lib.mkIf config.myModules.zsh.enable {
    programs.zsh.initContent = ''
      ls() { eza -al --color=always --group-directories-first --icons "$@" }
      la() { eza -a --color=always --group-directories-first --icons "$@" }
      ll() { eza -l --color=always --group-directories-first --icons "$@" }
      lt() { eza -aT --color=always --group-directories-first --icons "$@" }
      ld() { eza -ald --color=always --group-directories-first --icons .* "$@" }
      compdef _eza ls la ll lt ld
      #[[ -f ~/.key-bindings.zsh ]] && source ~/.key-bindings.zsh
      # Lancer fastfetch au login
      #if command -v fastfetch &> /dev/null; then
      #  fastfetch
      #fi
      ${lib.optionalString (starshipTheme == "strangership") ''
        if [ -f ~/.config/demogorgonascii.txt ]; then
          echo -e "\e[38;2;123;47;190m$(cat ~/.config/demogorgonascii.txt)\e[0m"
        fi
        sleep 1
        if [ -f ~/.config/strangernix.txt ]; then
          echo -e "\e[38;2;204;0;0m$(cat ~/.config/strangernix.txt)\e[0m"
        fi
      ''}
    '';
  };
}
