# modules/home-manager/tools.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.tools;
in

{
  options.myModules.tools = {
    ghostty.enable = lib.mkEnableOption "Ghostty terminal";
    vscode.enable = lib.mkEnableOption "VSCode editor";
    cli.enable = lib.mkEnableOption "CLI utilities (ripgrep, fd, jq...)";
    direnv.enable = lib.mkEnableOption "direnv (per-directory environment loading)";
    desktopApps.enable = lib.mkEnableOption "Desktop apps (Firefox, ...)";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.ghostty.enable {
      programs.ghostty = {
        enable = true;
        settings = {
          font-size = 12;
          window-decoration = true;
          confirm-close-surface = false;
          background-opacity = 0.5;
          background-blur-radius = 0;

          background = "1a0030";
          foreground = "ffffff";
        };
      };
    })

    (lib.mkIf cfg.vscode.enable {
      programs.vscode = {
        enable = true;
        #profiles.default = {
        #  userSettings = {
        #    "editor.formatOnSave" = true;
        #    "telemetry.telemetryLevel" = "off";
        #    "update.mode" = "none";
        #  };
        #};
      };
    })

    (lib.mkIf cfg.cli.enable {
      home.packages = with pkgs; [
        # Navigation / search
        ripgrep     # fast grep
        fd          # modern find
        ncdu        # interactive disk usage analyzer

        # File / archive utilities
        jq          # JSON manipulation
        unzip
        p7zip
      ];
    })

    (lib.mkIf cfg.direnv.enable {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    })

    (lib.mkIf cfg.desktopApps.enable {
      programs.firefox.enable = true;
    })
  ];
}
