{ config, lib, ... }:
{
  imports = [
    ./options.nix
    ./plugins.nix
    ./keymaps.nix
    ./lsp.nix
  ];

  options.myModules.nixvim = {
    enable = lib.mkEnableOption "configuration nixvim";
  };

  config = lib.mkIf config.myModules.nixvim.enable {
    programs.nixvim = {
      enable        = true;
      defaultEditor = true;
      viAlias       = true;
      vimAlias      = true;
      colorschemes.tokyonight = {
        enable = true;
        settings.style = "storm";
      };
    };
  };
}
