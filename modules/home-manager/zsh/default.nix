{ config, lib, ... }:

{
  imports = [
    ./plugins.nix
    ./initcontent.nix
    ./alias.nix
  ];

  options.myModules.zsh = {
    enable = lib.mkEnableOption "configuration zsh personnalisée";
  };

  config = lib.mkIf config.myModules.zsh.enable {
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
      ".config/demogorgonascii.txt".source = ../../home/dotfiles/starship/demogorgonascii.txt;
      ".config/strangernix.txt".source = ../../home/dotfiles/starship/strangernix.txt;
    };
  };
}
