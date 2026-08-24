# modules/system/desktop-environment/theming.nix
#
# Icon theme: Papirus-Dark with its default folders replaced
# by their violet variant.
#
# Note: the GTK theme, font and cursor are NOT managed here — DMS writes
# them dynamically via matugen to ~/.config/gtk-{3,4}.0/. Placing
# symlinks to the (read-only) store there would make matugen fail.
{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.desktopEnvironment;

  papirus-violet = pkgs.stdenvNoCC.mkDerivation {
    pname = "papirus-icon-theme-violet";
    inherit (pkgs.papirus-icon-theme) version;

    # No `src`: starting from the already-built package, so nothing to unpack.
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/icons
      # -L dereferences symlinks: without this, broken links pointing to
      # papirus-icon-theme's store path would be copied instead.
      cp -rL ${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark $out/share/icons/
      # The store is read-only, so the copy inherits its permissions.
      chmod -R u+w $out/share/icons/Papirus-Dark
      find $out/share/icons/Papirus-Dark -name "folder-violet*.svg" | while read -r f; do
        cp -f "$f" "$(echo "$f" | sed 's/folder-violet/folder/')"
      done
    '';
  };
in
{
  config = lib.mkIf cfg.theming.papirusViolet.enable {
    environment.systemPackages = [ papirus-violet ];
  };
}
