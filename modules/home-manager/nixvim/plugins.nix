{ config, lib, ... }:

let
  cfg = config.myModules.nixvim;
in

{
  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins = {
      web-devicons.enable = true;
      cmp-nvim-lsp.enable = true;
      luasnip.enable = true;
      smear-cursor.enable = true;

      nvim-tree = {
        enable = true;
        autoClose = true;
        settings = {
          diagnostics.enable = true;
          modified.enable = true;
        };
      };

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          folding.enable = true;
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
        };
      };

      lualine = {
        enable = true;
        settings.options.theme = "tokyonight";
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
          };
        };
      };
    };
  };
}
