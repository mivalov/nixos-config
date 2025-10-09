{
  lib,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = lib.mkDefault "Miroslav Valov";
    userEmail = lib.mkDefault "91765698+mivalov@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "vim";
      core.autocrlf = "input";
      pull.ff = "only";
    };
  };
}
