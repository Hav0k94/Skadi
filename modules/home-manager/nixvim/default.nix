{ config, lib, ... }:

let
  cfg = config.myModules.nixvim;
in

{
  imports = [
    ./options.nix
    ./plugins.nix
    ./keymaps.nix
    ./lsp.nix
  ];

  options.myModules.nixvim = {
    enable = lib.mkEnableOption "configuration nixvim";

    colorscheme = lib.mkOption {
      type    = lib.types.enum [ "storm" "night" "moon" "day" ];
      default = "storm";
      description = "Tokyonight colorscheme variant.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable        = true;
      defaultEditor = true;
      viAlias       = true;
      vimAlias      = true;
      colorschemes.tokyonight = {
        enable = true;
        settings.style = cfg.colorscheme;
      };
    };
  };
}
