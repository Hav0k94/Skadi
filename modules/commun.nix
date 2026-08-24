{ pkgs, localenv, starshipTheme, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit starshipTheme localenv; };

  environment.systemPackages = with pkgs; [
    tree
    vim
    curl
    jq
    btop
    wget
    gnupg
  ];
}
