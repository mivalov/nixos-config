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

    # https://github.com/zed-industries/extensions/tree/main/extensions
    extensions = [
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
      package-version-server
    ];

    userSettings = {
      agent_buffer_font_size = lib.mkDefault 14.0;
      agent_ui_font_size = lib.mkDefault 16.0;
      autosave = lib.mkDefault "on_focus_change";
      auto_update = lib.mkDefault false;
      base_keymap = lib.mkDefault "JetBrains";
      buffer_font_family = lib.mkDefault "JetBrainsMono Nerd Font Mono";
      buffer_font_size = lib.mkDefault 14.0;
      buffer_line_height = lib.mkDefault "comfortable";
      disable_ai = lib.mkDefault true;
      mouse_wheel_zoom = lib.mkDefault true;
      ui_font_family = lib.mkDefault "Adwaita Sans";
      ui_font_size = lib.mkDefault 16.0;

      git_panel = {
        dock = lib.mkDefault "left";
      };
      icon_theme = {
        mode = lib.mkDefault "system";
        light = lib.mkDefault "Zed (Default)";
        dark = lib.mkDefault "Zed (Default)";
      };
      project_panel = {
        dock = lib.mkDefault "left";
      };
      terminal = {
        dock = lib.mkDefault "bottom";
      };
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
          format_on_save = lib.mkDefault "off";
          hard_tabs = lib.mkDefault false;
          tab_size = lib.mkDefault 2;
        };
        Nix = {
          formatter = lib.mkDefault "language_server";
          format_on_save = lib.mkDefault "off";
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };

      lsp = {
        nixd.settings.nixd.formatting.command = [ "nixfmt" ];
        package-version-server.binary.path = lib.mkDefault "package-version-server";
      };
    };

    # https://zed.dev/docs/key-bindings
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-y" = "editor::Redo";
          "ctrl-#" = [
            "editor::ToggleComments"
            { advance_downwards = true; }
          ];
        };
      }
    ];
  };
}
