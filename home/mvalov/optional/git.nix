{
  lib,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = lib.mkDefault "Miroslav Valov";
      user.email = lib.mkDefault "91765698+mivalov@users.noreply.github.com";
      alias = {
        logs = "log --graph --all --abbrev-commit --pretty=format:'%C(auto)%h%Creset -%C(auto)%d%Creset %s %C(brightyellow)(%cr) %C(bold brightblue)[%an]%Creset'";
      };
      init.defaultBranch = lib.mkDefault "main";
      core.editor = lib.mkDefault "vim";
      core.autocrlf = lib.mkDefault "input";
      pull.ff = lib.mkDefault "only";
    };
  };
}
