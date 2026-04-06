{ config, lib, ... }:
{
  config = lib.mkIf config.myModules.nixvim.enable {
    programs.nixvim = {
      keymaps = [
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
