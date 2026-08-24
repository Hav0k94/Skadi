# modules/system/fonts.nix
{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.fonts;
in
{
  options.myModules.fonts = {
    enable = lib.mkEnableOption "polices système";

    monospace = lib.mkOption {
      type = lib.types.str;
      default = "FiraCode Nerd Font";
      description = "Police monospace par défaut (terminal, éditeurs)";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      inter
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [ cfg.monospace ];
    };
  };
}
