{
  lib,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = lib.mkDefault "Miroslav Valov";
    userEmail = lib.mkDefault "91765698+mivalov@users.noreply.github.com";
    aliases = {
      logs = "--graph --all --abbrev-commit --pretty=format:'%C(auto)%h%Creset -%C(auto)%d%Creset %s %C(brightyellow)(%cr) %C(bold brightblue)[%an]%Creset'";
    };
    extraConfig = {
      init.defaultBranch = lib.mkDefault "main";
      core.editor = lib.mkDefault "vim";
      core.autocrlf = lib.mkDefault "input";
      pull.ff = lib.mkDefault "only";
    };
  };
}
