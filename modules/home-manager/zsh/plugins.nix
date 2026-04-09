{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.zsh;
  ohmyzsh = pkgs.fetchFromGitHub {
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    rev = "52d93f18d61f11db69b4591d7fc7bd5578954d30";  # Last Commit 19/02/2026
    sha256 = "sha256-fGFPVHbJFtXvuiR0yOc9Qt1TUuIfNAYezGQtESt9REA=";
  };
  omzPlugin = name: {
    inherit name;
    src  = ohmyzsh;
    file = "plugins/${name}/${name}.plugin.zsh";
  };
in

{
config = lib.mkIf cfg.enable {
  programs.zsh.plugins = [
    {
      name = "fzf-tab";
      src = pkgs.fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "747c15de85a38748b28c29ac65616137dbb4c8b6";
        sha256 = "sha256-gatFp2kjyqaqi8hu0UWPDtQAy+X2VmyYNPP4aiNDdHg=";
      };
      file = "fzf-tab.plugin.zsh";
    }

    (omzPlugin "git")
    (omzPlugin "sudo")
    (omzPlugin "docker")
    (omzPlugin "history")
    ];
  };
}
