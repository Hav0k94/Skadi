{ config, lib, ... }:
{
  options.myModules.nftables = {
    enable = lib.mkEnableOption "nftables firewall";
    configFile = lib.mkOption {
      type = lib.types.path;
      default  = ./conf/nftables-default.conf;
      description = "Chemin vers le fichier nftables.conf";
    };
  };
  config = lib.mkIf config.myModules.nftables.enable {
    networking.firewall.enable = false;
    networking.nftables.enable = true;
    networking.nftables.rulesetFile = config.myModules.nftables.configFile;
  };
}
