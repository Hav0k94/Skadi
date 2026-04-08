# modules/home-manager/git.nix
{ config, lib, localenv, ... }:

let
  cfg = config.myModules.git;
in

{
  options.myModules.git = {
    enable = lib.mkEnableOption "configuration git personnalisée";

    signingKey = lib.mkOption {
      type = lib.types.str;
      description = "Chemin vers la clé publique SSH pour signer les commits";
      # Pas de `default` volontairement — force à le déclarer explicitement
    };

    signingKeyContent = lib.mkOption {
      type = lib.types.str;
      description = "Contenu brut de la clé publique SSH (ex: ssh-ed25519 AAAAC3Nza...)";
      # Pas de `default` volontairement — force à le déclarer explicitement
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = lib.hasPrefix "ssh-" cfg.signingKeyContent
               || lib.hasPrefix "ecdsa-" cfg.signingKeyContent;
      message = "myModules.git: signingKeyContent must be a valid SSH public key.";
    }];
    programs.git = {
      enable = true;
      settings = {
        user.name  = localenv.user.name;
        user.email = localenv.user.mail;
        init.defaultBranch = "main";
        pull.rebase        = true;
        # Requis pour que `git log --show-signature` fonctionne
        gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      };
      
      # Signer les commits avec une clé SSH (moderne, plus simple que GPG)
      signing = {
        key = cfg.signingKey;
        signByDefault = true;
        format = "ssh";
      };
    };
    home.file.".config/git/allowed_signers".text = ''
      ${localenv.user.mail} ${cfg.signingKeyContent}
    '';
  };
}
