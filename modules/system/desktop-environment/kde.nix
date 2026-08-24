# modules/system/desktop-environment/kde.nix
#
# KDE Plasma 6, kept as a fallback session alongside Hyprland.
# SDDM is declared in default.nix (shared by both).
{ config, lib, ... }:

let
  cfg = config.myModules.desktopEnvironment;
in
{
  config = lib.mkIf cfg.kde.enable {
    services.desktopManager.plasma6.enable = true;

    # Plasma 6 runs on Wayland without an X server. This line is only useful
    # to keep an X11 session selectable in SDDM; you can remove it
    # if you never use it (it pulls in all of xserver).
    services.xserver.enable = true;
  };
}