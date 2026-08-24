# modules/system/desktop-environment/default.nix
#
# Entry point for the "desktop environment" system module.
# Exposes myModules.desktopEnvironment and groups together:
#   - kde.nix       : Plasma 6
#   - hyprland.nix  : compositor + XDG portals
#   - dms.nix       : DankMaterialShell + plugins
#   - theming.nix   : purple Papirus icon theme
#
# The *user* side of Hyprland (binds, rules, appearance) lives elsewhere:
#   modules/home-manager/hyprland/  (myModules.hyprland)
{ config, lib, ... }:

let
  cfg = config.myModules.desktopEnvironment;
in
{
  imports = [
    ./kde.nix
    ./hyprland.nix
    ./dms.nix
    ./theming.nix
  ];

  options.myModules.desktopEnvironment = {
    kde.enable = lib.mkEnableOption "KDE Plasma 6";
    hyprland.enable = lib.mkEnableOption "Hyprland";

    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "fr";
      description = "X11/Wayland keyboard layout (services.xserver.xkb.layout).";
    };

    dms = {
      # No mkEnableOption here: we want a *computed* default (follows Hyprland),
      # which mkEnableOption doesn't allow (it forces default = false).
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.hyprland.enable;
        defaultText = lib.literalExpression "config.myModules.desktopEnvironment.hyprland.enable";
        description = ''
          DankMaterialShell: bar, launcher, lockscreen, notifications.
        '';
      };

      plugins.minflairKeybinds.enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.dms.enable;
        defaultText = lib.literalExpression "config.myModules.desktopEnvironment.dms.enable";
        description = ''
          QML "cheat sheet" plugin for keybinds.
          Triggered by `dms ipc call minflairKeybinds toggle` ($mod + K).
        '';
      };
    };

    theming.papirusViolet.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.hyprland.enable;
      defaultText = lib.literalExpression "config.myModules.desktopEnvironment.hyprland.enable";
      description = "Papirus-Dark with folders recolored in violet.";
    };
  };

  # Block shared by both DE/WM: as soon as at least one of the two is active.
  config = lib.mkIf (cfg.kde.enable || cfg.hyprland.enable) {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.xserver.xkb = {
      layout = cfg.keyboardLayout;
      variant = "";
    };
  };
}
