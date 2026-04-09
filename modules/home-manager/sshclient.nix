{ config, lib, localenv, ... }:

let
  cfg = config.myModules.sshClient;
in

{
  options.myModules.sshClient = {
    enable = lib.mkEnableOption "SSH client configuration";
  };

  config = lib.mkIf cfg.enable {  
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*.serveur" = {
          user = localenv.user.name;
          port = 2222;
        };
        "*.vps" = {
          user = localenv.user.name;
          port = 22;
        };
        "*" = {
          addKeysToAgent = "yes";  # s'applique à tous les hôtes
          serverAliveInterval = 60;  # évite les déconnexions sur sessions idle
          serverAliveCountMax = 3;
          identityFile = "~/.ssh/id_ed25519";  # clé par défaut pour tous les hôtes
        };
      };
    };
  };
}
