{
  lib,
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.unstable.zed-editor;
    defaultEditor = lib.mkDefault false;
    mutableUserSettings = lib.mkDefault true;
    mutableUserKeymaps = lib.mkDefault true;
    mutableUserTasks = lib.mkDefault true;
    mutableUserDebug = lib.mkDefault true;

    userSettings = {
      autosave = lib.mkDefault "on_focus_change";
      auto_update = lib.mkDefault false;
      base_keymap = lib.mkDefault "JetBrains";
      buffer_font_family = lib.mkDefault "JetBrainsMono Nerd Font Mono";
      buffer_font_size = lib.mkDefault 14.0;
      agent_buffer_font_size = lib.mkDefault 14.0;
      buffer_line_height = lib.mkDefault "comfortable";
      mouse_wheel_zoom = lib.mkDefault true;
      ui_font_family = lib.mkDefault "Adwaita Sans";
      ui_font_size = lib.mkDefault 16.0;
      agent_ui_font_size = lib.mkDefault 16.0;
      telemetry = {
        diagnostics = lib.mkDefault false;
        metrics = lib.mkDefault false;
      };
      theme = {
        mode = lib.mkDefault "system";
        light = lib.mkDefault "JetBrains Light";
        dark = lib.mkDefault "JetBrains Islands Dark";
      };
    };

    extensions = [
      # https://github.com/zed-industries/extensions/tree/main/extensions
      "catppuccin"
      "git-firefly"
      "html"
      "jetbrains-themes"
      "nix"
      "toml"
    ];
  };
}
