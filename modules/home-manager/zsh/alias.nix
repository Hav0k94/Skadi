{ config, lib, ... }:

{
  config = lib.mkIf config.myModules.zsh.enable {
    programs.zsh.shellAliases = {
      # Better cat
      cat = "bat --style header --style snip --style changes --style header";
      # NixOS rebuild
      update-wsl = "sudo nixos-rebuild switch --flake './#wsl'";
      update-vps = "sudo nixos-rebuild switch --flake './#vps'";
      # Garbage collect
      gc = "sudo nix-collect-garbage --delete-older-than 7d";
      # Alias nvim
      svim = "sudo -E nvim";
    };
  };
}
