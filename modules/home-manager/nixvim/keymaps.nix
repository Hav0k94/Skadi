{ config, lib, ... }:

let
  cfg = config.myModules.nixvim;
in

{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      keymaps = [
        #NvimTree
        {
          mode   = "n";
          key    = "<C-n>";
          action = ":NvimTreeToggle<CR>";
        }
      ];
      userCommands = {
        "Diag" = {
          command = "lua vim.diagnostic.setqflist()";
          desc    = "Show diagnostics";
        };
      };
    };
  };
}
