{ starshipTheme, localenv,... }:

{
  imports = [ 
    ./modules/commun.nix
    ./modules/system
  ];

  myModules.ssh = {
    enable = true;
    port = 22;
    allowedUsers = [ localenv.user.name ];
    logLevel = "INFO";
  };
  
  home-manager.extraSpecialArgs = { inherit starshipTheme localenv; };


  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
	
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";
}
