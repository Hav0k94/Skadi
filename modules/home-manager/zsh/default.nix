{ config, lib, ... }:

let
  cfg = config.myModules.zsh;
in

{
  imports = [
    ./plugins.nix
    ./initcontent.nix
    ./alias.nix
  ];

  options.myModules.zsh = {
    enable = lib.mkEnableOption "configuration zsh personnalisée";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      syntaxHighlighting = {
        enable = true;
        styles = {
          alias = "fg=magenta,bold";
          path = "fg=cyan";
          unknown-token = "fg=red,bold";
          precommand = "fg=#a3aed2,bold";
          command = "fg=#a3aed2";
          builtin = "fg=#a3aed2";
        };
      };
    };
    home.file = {
      ".config/zsh/demogorgonascii.txt".source = ../../home/dotfiles/starship/demogorgonascii.txt;
      ".config/zsh/strangernix.txt".source = ../../home/dotfiles/starship/strangernix.txt;
    };
  };
}
