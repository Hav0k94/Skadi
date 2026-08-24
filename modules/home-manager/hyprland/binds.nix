# modules/home-manager/hyprland/binds.nix
#
# Keyboard and mouse shortcuts.
# The DMS-related binds are isolated so Hyprland can be tested without DMS
# (myModules.hyprland.dms.enable = false).
{ config, lib, ... }:

let
  cfg = config.myModules.hyprland;

  # Physical keys 1..0 = code:10..code:19 (X11 keycode = scancode + 8).
  # Layout-independent, so this works on AZERTY.
  workspaceBinds = lib.concatMap
    (i: [
      "$mod, code:${toString (9 + i)}, workspace, ${toString i}"
      "$mod SHIFT, code:${toString (9 + i)}, movetoworkspace, ${toString i}"
    ])
    (lib.range 1 cfg.workspaceCount);

  baseBinds = [
    # ── Applications ──────────────────────────────────────────────────────
    "$mod, RETURN, exec, ${cfg.terminal}"
    "$mod, E, exec, ${cfg.fileManager}"

    # ── Windows ───────────────────────────────────────────────────────────
    "$mod, Q, killactive" # close the active window
    "$mod, M, exit" # quit Hyprland (back to SDDM)
    "$mod, V, togglefloating" # tiling <-> floating
    "$mod, F, fullscreen"

    # ── Scratchpad ────────────────────────────────────────────────────────
    "$mod SHIFT, U, movetoworkspace, special"
    "$mod, U, togglespecialworkspace,"

    # ── Focus ─────────────────────────────────────────────────────────────
    "$mod, left, movefocus, l"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"

    # ── Resizing ──────────────────────────────────────────────────────────
    "$mod ALT, right, resizeactive, 20 0"
    "$mod ALT, left, resizeactive, -20 0"
    "$mod ALT, up, resizeactive, 0 -20"
    "$mod ALT, down, resizeactive, 0 20"

    # ── Workspace navigation via scroll wheel ────────────────────────────
    "$mod, mouse_down, workspace, e+1"
    "$mod, mouse_up, workspace, e-1"
  ];

  # DMS surfaces, all driven via IPC.
  # `dms ipc` with no argument lists the targets and their functions.
  dmsBinds = [
    "$mod, SPACE, exec, dms ipc call spotlight toggle" # launcher (formerly wofi)
    "$mod, D, exec, dms ipc call dash toggle" # dashboard
    "$mod SHIFT, W, exec, dms ipc call dash toggle wallpaper" # wallpaper picker
    "$mod, K, exec, dms ipc call minflairKeybinds toggle" # cheat sheet (plugin)
    "$mod, S, exec, dms ipc call settings toggle"
    "$mod, C, exec, dms ipc call control-center toggle"
    "$mod SHIFT, V, exec, dms ipc call clipboard toggle"
    "$mod, TAB, exec, dms ipc call hypr toggleOverview"
    "$mod, L, exec, dms ipc call lock lock" # formerly hyprlock
    "$mod SHIFT, E, exec, dms ipc call powermenu toggle" # formerly wlogout

    # Screenshot: dedicated CLI, no IPC.
    # Check the subcommands with `dms screenshot --help`.
    "$mod SHIFT, S, exec, dms screenshot region"
  ];
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";

      bind = baseBinds ++ workspaceBinds ++ lib.optionals cfg.dms.enable dmsBinds;

      # bindle = active while screen locked + repeats if the key is held
      bindle = lib.optionals cfg.dms.enable [
        ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 5"
        ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 5"
        ", XF86MonBrightnessUp, exec, dms ipc call brightness increment 5"
        ", XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5"
      ];

      # bindl = active while screen locked, no repeat
      bindl = lib.optionals cfg.dms.enable [
        ", XF86AudioMute, exec, dms ipc call audio mute"
        ", XF86AudioMicMute, exec, dms ipc call audio micmute"
        ", XF86AudioPlay, exec, dms ipc call mpris playPause"
        ", XF86AudioNext, exec, dms ipc call mpris next"
        ", XF86AudioPrev, exec, dms ipc call mpris previous"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
