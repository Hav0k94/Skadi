{ config, lib, ... }:

let
  cfg = config.myModules.nixvim;
in

{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      globals.mapleader = " ";
      opts = {
        number = true;
        relativenumber = true;
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        termguicolors = true;
        splitright = true;
        splitbelow = true;
      };
    };
  };
}
