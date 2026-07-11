{
  lib,
  pkgs,
  ...
}:
{
  # https://wiki.nixos.org/wiki/Zed
  programs.zed-editor = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.unstable.zed-editor;
    defaultEditor = lib.mkDefault false;
    mutableUserSettings = lib.mkDefault true;
    mutableUserKeymaps = lib.mkDefault true;
    mutableUserTasks = lib.mkDefault true;
    mutableUserDebug = lib.mkDefault true;
    extensions = [
      # https://github.com/zed-industries/extensions/tree/main/extensions
      "catppuccin"
      "git-firefly"
      "html"
      "jetbrains-themes"
      "nix"
      "toml"
    ];

    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];

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

      languages = {
        Markdown = {
          formatter = lib.mkDefault "language_server";
          tab_size = lib.mkDefault 4;
          hard_tabs = lib.mkDefault false;
        };
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter = lib.mkDefault "language_server";
          format_on_save = lib.mkDefault "on";
        };
      };

      lsp = {
        nixd.settings.nixd.formatting.command = [ "nixfmt" ];
      };
    };

    # https://zed.dev/docs/key-bindings
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-#" = [
            "editor::ToggleComments"
            { advance_downwards = true; }
          ];
        };
      }
    ];
  };
}
