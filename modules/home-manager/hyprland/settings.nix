# modules/home-manager/hyprland/settings.nix
#
# Monitors, input devices and appearance.
{ config, lib, ... }:

let
  cfg = config.myModules.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      monitor = [ ",preferred,auto,1" ];

      input = {
        kb_layout = cfg.keyboardLayout;
      };

      general = {
        border_size = 2;
        gaps_in = 2;
        gaps_out = 4;
        # col.active_border / col.inactive_border are not set here:
        # DMS regenerates them on every wallpaper change in
        # ~/.config/hypr/dms/colors.conf (sourced from dms.nix).
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 3;
          render_power = 1;
        };

        blur = {
          enabled = true;
          size = 6;
          passes = 1;
          ignore_opacity = false;
        };
      };

      animations = {
        enabled = true;
        # Curves must be declared before the animations that use them.
        # Home Manager takes care of this: "bezier" is one of the prefixes
        # written at the top of the file, regardless of the merge order
        # between this file and the others.
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, once"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
          "specialWorkspace, 1, 5, wind, slidevert"
        ];
      };
    };
  };
}
