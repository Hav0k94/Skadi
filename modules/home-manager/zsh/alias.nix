{ config, lib, ... }:

let
  cfg = config.myModules.zsh;
in

{
  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases = {
      # Better cat
      cat = "bat --style=header,snip,changes";
      # NixOS rebuild
      update-wsl = "sudo nixos-rebuild switch --flake './#wsl'";
      update-vps = "sudo nixos-rebuild switch --flake './#vps'";
      # Garbage collect
      gc = "sudo nix-collect-garbage --delete-older-than 7d";
      gc-dry = "sudo nix-collect-garbage --delete-older-than 7d --dry-run";
      # Alias nvim
      svim = "sudo -E nvim";
    };
  };
}
