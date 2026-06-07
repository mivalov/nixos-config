{
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    # Pull in nvf's Home Manager module before setting local defaults below.
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;
    # Keep documentation available unless a host/user module opts out.
    enableManpages = mkDefault true;
    defaultEditor = mkDefault false;

    settings.vim = {
      # Prefer Neovim as the implementation for common vi/vim entrypoints.
      viAlias = mkDefault false;
      vimAlias = mkDefault false;
      enableLuaLoader = mkDefault true;
      withPython3 = mkDefault true;

      globals = {
        # Space is the primary leader; comma stays free for buffer-local mappings.
        mapleader = mkDefault " ";
        maplocalleader = mkDefault ",";
      };

      options = {
        # Establish editing defaults while leaving room for narrower modules to override.
        number = mkDefault true;
        relativenumber = mkDefault true;
        tabstop = mkDefault 2;
        shiftwidth = mkDefault 2;
        expandtab = mkDefault true;
        smartindent = mkDefault true;
        wrap = mkDefault false;
        signcolumn = mkDefault "yes";
        splitbelow = mkDefault true;
        splitright = mkDefault true;
        updatetime = mkDefault 250;
      };

      theme = {
        # Set a baseline theme without making it mandatory.
        enable = mkDefault true;
        name = mkDefault "onedark";
      };

      # Core IDE-style features enabled by default for every nvf profile.
      lsp.enable = mkDefault true;
      treesitter.enable = mkDefault true;
      telescope.enable = mkDefault true;
      statusline.lualine.enable = mkDefault true;
      git.gitsigns.enable = mkDefault true;

      filetree.neo-tree.enable = mkDefault false;
    };
  };

  home.sessionVariables = {
    # Point terminal tools at the same editor configured above.
    EDITOR = mkDefault "nvim";
    VISUAL = mkDefault "nvim";
  };
}
