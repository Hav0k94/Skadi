{
  description = "Mes configurations NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, home-manager, nixvim, ... }:
  let
    system = "x86_64-linux";
    localenv = import ./localenv.nix;

    mkHost = { modules, specialArgs ? {} }: nixpkgs.lib.nixosSystem {
      inherit system modules;
      specialArgs = specialArgs // { inherit localenv; };
    };
  in
  {
    nixosConfigurations = {
      # Host WSL
      wsl = mkHost {
      specialArgs = { starshipTheme = "tokyo-night"; };
      modules = [
        nixos-wsl.nixosModules.wsl
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit localenv; };
          home-manager.sharedModules = [
          nixvim.homeModules.nixvim
          ];
        }
        ./hosts/wsl.nix
	      ./configuration-wsl.nix
        ];
      };
      
      # Host VPS
      vps = mkHost {
      specialArgs = { starshipTheme = "strangership"; };
      modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit localenv; };
          home-manager.sharedModules = [
          nixvim.homeModules.nixvim
          ];
        }
        ./hosts/vps.nix
	      ./configuration-vps.nix
      ];
      };
      
    };
  };
}

