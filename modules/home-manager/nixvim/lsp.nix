{ config, lib, ... }:

let
  cfg = config.myModules.nixvim;
in

{
  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.lsp = {
      enable = true;
      servers = {
        nixd.enable = true; # Nix
        pyright.enable = true; # Python
      };
    };
  };
}
