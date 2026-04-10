{ config, lib, ... }:
{
  config = lib.mkIf config.myModules.nixvim.enable {
    programs.nixvim = {
      keymaps = [
        # NvimTree
        {
          mode   = "n";
          key    = "<C-n>";
          action = ":NvimTreeToggle<CR>";
        }
        # LazyGit
        {
          mode    = "n";
          key     = "<leader>gg";
          action  = "<cmd>LazyGit<cr>";
          options.desc = "LazyGit";
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
