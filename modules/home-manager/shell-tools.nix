# modules/home-manager/shell-tools.nix
{ config, lib, pkgs, ... }:

let
  # Map themes → fichier TOML
  themes = {
    tokyo-night = ../../home/dotfiles/starship/tokyo-night.toml;
    strangership  = ../../home/dotfiles/starship/strangership.toml;
    garuda-starship = ../../home/dotfiles/starship/garuda-starship.toml;
  };
in

{
  options.myModules.shellTools = {
    enable = lib.mkEnableOption "outils shell (starship, fzf, fastfetch...)";
    starship.theme = lib.mkOption {
      type    = lib.types.enum (lib.attrNames themes);
      default = "tokyo-night";
      description = "Thème starship à utiliser";
    };
  };

  config = lib.mkIf config.myModules.shellTools.enable {

    programs.starship = {
      enable   = true;
      settings = builtins.fromTOML (builtins.readFile themes.${config.myModules.shellTools.starship.theme});
    };

    programs.fzf = {
      enable              = true;
      enableZshIntegration = true;
    };

    home.packages = with pkgs; [
      eza        # ls moderne
      bat        # cat moderne
      fastfetch  # system info au login
    ];
  };
}
