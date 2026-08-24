{ ... }:

{
  imports = [
    ./nftables
    ./openssh.nix
    ./fonts.nix
    ./desktop-environment
    ./pkgs-unfree.nix
  ];
}
