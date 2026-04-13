{ config, lib, ... }:

let
  cfg = config.myModules.tmux;
in

{
  options.myModules.tmux = {
    enable = lib.mkEnableOption "Configuration tmux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      # Rebind prefix de Ctrl+b → Ctrl+a (plus ergonomique)
      prefix = "C-a";

      # Numérotation des fenêtres à partir de 1
      baseIndex = 1;

      # Activer la souris (scroll, clic sur panneaux)
      mouse = true;

      # Terminal avec support 256 couleurs
      terminal = "screen-256color";

      # Config brute injectée dans ~/.tmux.conf
      extraConfig = ''
        # Recharger la config sans redémarrer
        bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

        # Splits plus intuitifs
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        # Navigation entre panneaux avec Alt+flèches
        bind -n M-Left  select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up    select-pane -U
        bind -n M-Down  select-pane -D

        # Synchronisation de sessions pour Multi-Exec
        bind S set synchronize-panes \; display "Synchronize-panes: #{?synchronize-panes,ON,OFF}"
      '';
    };
  };
}
