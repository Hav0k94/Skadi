# modules/home-manager/hyprland/rules.nix
#
# Window and layer rules.
# Goes through extraConfig rather than settings: Hyprland's `layerrule { ... }`
# syntax doesn't render correctly from a Nix attrset.
#
# extraConfig is of type `lines`: mkMerge concatenates the fragments, so this
# module and dms.nix can both write to it.
{ config, lib, ... }:

let
  cfg = config.myModules.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.extraConfig = lib.mkMerge [
      # Blur behind DMS surfaces (bar, spotlight, dashboard).
      # ignore_alpha 0.2: doesn't blur near-transparent areas,
      # otherwise DMS's drop shadows turn into gray halos.
      (lib.mkIf cfg.dms.enable ''
        layerrule {
          name = dms_blur
          match:namespace = ^(dms:).*
          blur = true
          ignore_alpha = 0.2
        }
      '')

      ''
        windowrule = opacity 0.85, match:class ^(org\.gnome\.Nautilus)$
        windowrule = float on, match:class ^(org\.gnome\.Nautilus)$
        windowrule = size 1000 650, match:class ^(org\.gnome\.Nautilus)$
      ''
    ];
  };
}
