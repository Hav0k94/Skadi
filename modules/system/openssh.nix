{ config, lib, ... }:

let
  cfg = config.myModules.ssh;
in

{
  options.myModules.ssh = {
    enable = lib.mkEnableOption "SSH server";
    port = lib.mkOption {
      type = lib.types.port;
      default = 22;
      description = "Port for the SSH server";
    };
    allowedUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Utilisateurs autorisés à se connecter via SSH. Liste vide = pas de restriction.";
    };
    logLevel = lib.mkOption {
      type = lib.types.enum [ "QUIET" "FATAL" "ERROR" "INFO" "VERBOSE" "DEBUG" "DEBUG1" "DEBUG2" "DEBUG3" ];
      default = "INFO";
      description = "SSH log verbosity level.";
    };
  };
  config = lib.mkIf cfg.enable {
    users.users.root.hashedPassword = "!"; # Désactive connexion via Root, seulement accessible via sudo

    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      # Génère uniquement des host keys modernes, supprime les clés RSA/DSA legacy
      hostKeys = [ 
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      settings = {
        # --- Authentification ---
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AuthenticationMethods = "publickey";

        # --- Restriction utilisateurs ---
        AllowUsers = lib.mkIf (cfg.allowedUsers != []) cfg.allowedUsers;

        # --- Réduction de surface ---
        X11Forwarding = false;
        AllowTcpForwarding = false;
        AllowAgentForwarding = false;
        PermitTunnel = false;

        # --- Brute-force mitigation ---
        MaxAuthTries = 3;
        MaxSessions  = 2;

        # --- Stabilité des sessions ---
        ClientAliveInterval = 60;
        ClientAliveCountMax = 3;
        LoginGraceTime = 30;

        # --- Hardening crypto ---
        KexAlgorithms = [
          "mlkem768x25519-sha256"        # post-quantique, OpenSSH 9.9+
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
        ];
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];

        LogLevel = cfg.logLevel;
      };
    };
  };
}
