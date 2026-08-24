{ starshipTheme, localenv, osConfig, ... }:

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
  myModules.sshClient.enable = true;
  myModules.tmux.enable = true;
  myModules.tools = {
    vscode.enable = true;
    cli.enable = true;
    direnv.enable = true;
    desktopApps.enable = true;
    # Graphical terminal: only makes sense on a host with a desktop
    # environment (see myModules.desktopEnvironment.hyprland on the system side).
    ghostty.enable = osConfig.myModules.desktopEnvironment.hyprland.enable;
  };
  myModules.fastfetch.enable = true;

  # Follows the system: enabled only on hosts that declare
  # myModules.desktopEnvironment.hyprland.enable (typically the laptop).
  myModules.hyprland.enable = osConfig.myModules.desktopEnvironment.hyprland.enable;
}
