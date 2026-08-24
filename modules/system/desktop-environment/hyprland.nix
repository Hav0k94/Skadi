
# modules/system/desktop-environment/hyprland.nix
#
# The *system* side of Hyprland: the compositor itself, the session listed
# in SDDM, and the XDG portals.
# The user configuration (binds, appearance, exec-once) is in
# modules/home-manager/hyprland/.
{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.desktopEnvironment;
in
{
  config = lib.mkIf cfg.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Forces Electron/Chromium applications to native Wayland
    # (otherwise XWayland: blurry rendering on HiDPI screens, no fractional scaling).
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland # screencast, screenshot, window picker
        pkgs.xdg-desktop-portal-gtk # Settings (color-scheme, accent-color), file chooser
      ];
      # Without this explicit routing rule, the chosen portal depends on
      # the D-Bus registration order: screen sharing then randomly falls
      # back to gtk, which can't do it under Hyprland.
      config = {
        common.default = [ "gtk" ];
        Hyprland.default = [ "hyprland" "gtk" ];
      };
    };
  };
}
