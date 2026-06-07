{
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  # Keep Nix-specific editor behavior in its own module so it can be imported selectively.
  programs.nvf.settings.vim.languages.nix = {
    enable = true;

    lsp = {
      # nixd is the default Nix language server, but callers can replace it.
      enable = mkDefault true;
      servers = mkDefault [ "nixd" ];
    };

    format = {
      # Match the repo's formatter convention unless a host/user module overrides it.
      enable = mkDefault true;
      type = mkDefault "nixfmt";
    };

    # Treesitter handles syntax-aware highlighting; extra diagnostics catch Nix issues earlier.
    treesitter.enable = mkDefault true;
    extraDiagnostics.enable = mkDefault true;
  };
}
