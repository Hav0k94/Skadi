{ config, lib, pkgs,... }:

# Variable pour ajouter des plugins à zsh sans OhMyZsh
let
    plugins_zsh = pkgs.fetchFromGitHub {
      owner = "ohmyzsh";
      repo = "ohmyzsh";
      rev = "52d93f18d61f11db69b4591d7fc7bd5578954d30";  # Last Commit 19/02/2026
      sha256 = "sha256-fGFPVHbJFtXvuiR0yOc9Qt1TUuIfNAYezGQtESt9REA=";
    };
in

{
config = lib.mkIf config.myModules.zsh.enable {
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

    { name = "git"; src = plugins_zsh; file = "plugins/git/git.plugin.zsh"; }
    { name = "sudo"; src = plugins_zsh; file = "plugins/sudo/sudo.plugin.zsh"; }
    { name = "docker"; src = plugins_zsh; file = "plugins/docker/docker.plugin.zsh"; }
    { name = "history"; src = plugins_zsh; file = "plugins/history/history.plugin.zsh"; }
    { name = "command-not-found"; src = plugins_zsh; file = "plugins/command-not-found/command-not-found.plugin.zsh"; }
    ];
  };
}
