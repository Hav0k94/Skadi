# modules/system/desktop-environment/dms.nix
#
# DankMaterialShell (nixpkgs module `programs.dms-shell`, present since 26.05).
#
# Why on the system side and not Home Manager: the module installs plugins
# via `environment.etc` (-> /etc/xdg/quickshell/dms-plugins/<name>). There is
# no HM equivalent in nixpkgs, so the plugin declaration has to live
# here, with its QML assets in ./dms-plugins/.
{ config, lib, ... }:

let
  cfg = config.myModules.desktopEnvironment;
in
{
  config = lib.mkIf cfg.dms.enable {
    programs.dms-shell = {
      enable = true;

      # `dms run` is launched via exec-once on the Home Manager side.
      # Reason: wayland.windowManager.hyprland.systemd.enable = false, so
      # graphical-session.target is never reached and dms.service would stay
      # stuck waiting indefinitely.
      systemd.enable = false;

      # NB: enableDynamicTheming (matugen), enableSystemMonitoring (dgop),
      # enableAudioWavelength (cava), enableVPN, enableCalendarEvents (khal) and
      # enableClipboardPaste (wtype) all default to `true` in nixpkgs.
      # So only what deviates from the default is declared here. To lighten the closure:
      #   enableCalendarEvents = false;  # khal
      #   enableVPN = false;             # glib + networkmanager

      # The attribute name determines the installed folder's name:
      #   /etc/xdg/quickshell/dms-plugins/minflairKeybinds
      plugins.minflairKeybinds = {
        enable = cfg.dms.plugins.minflairKeybinds.enable;
        src = ./dms-plugins/MinflairKeybinds;
      };
    };
  };
}
