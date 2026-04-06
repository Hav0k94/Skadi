{ starshipTheme, localenv, ... }:

{
  imports = [ ../modules/home-manager ];
    
  home.username = localenv.user.name;
  home.homeDirectory = "/home/${localenv.user.name}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  myModules.shellTools = {
    enable = true;
    starship.theme = starshipTheme;
  };
  myModules.zsh.enable = true;
  myModules.nixvim.enable = true;
  myModules.git = {
    enable = true;
    signingKey = localenv.git.signingKey;
    signingKeyContent = localenv.git.signingKeyContent;
  };
}
