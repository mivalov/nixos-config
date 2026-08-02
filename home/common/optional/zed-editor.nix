{
  lib,
  pkgs,
  ...
}:
{
  # https://panache.bz/guide/configuration.html
  xdg.configFile."panache/config.toml".text = lib.mkDefault ''
    [extensions]
    alerts = true
  '';

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
      "panache-language-server"
      "toml"
    ];

    extraPackages = with pkgs; [
      nixd
      nixfmt
      package-version-server
      panache
    ];

    # https://zed.dev/docs/reference/all-settings
    userSettings = {
      # Editor behaviour
      autosave = lib.mkDefault "on_focus_change";
      auto_update = lib.mkDefault false;
      base_keymap = lib.mkDefault "JetBrains";
      disable_ai = lib.mkDefault true;
      format_on_save = lib.mkDefault "off";
      mouse_wheel_zoom = lib.mkDefault true;

      # https://zed.dev/docs/appearance
      # Fonts
      agent_buffer_font_size = lib.mkDefault 14.0;
      agent_ui_font_size = lib.mkDefault 16.0;
      buffer_font_family = lib.mkDefault "JetBrainsMono Nerd Font Mono";
      buffer_font_size = lib.mkDefault 14.0;
      buffer_line_height = lib.mkDefault "comfortable";
      ui_font_family = lib.mkDefault "Adwaita Sans";
      ui_font_size = lib.mkDefault 16.0;

      # Themes
      icon_theme = {
        mode = lib.mkDefault "system";
        light = lib.mkDefault "Zed (Default)";
        dark = lib.mkDefault "Zed (Default)";
      };
      theme = {
        mode = lib.mkDefault "system";
        light = lib.mkDefault "JetBrains Light";
        dark = lib.mkDefault "JetBrains Islands Dark";
      };

      # Panels
      git_panel = {
        dock = lib.mkDefault "left";
      };
      project_panel = {
        dock = lib.mkDefault "left";
      };
      terminal = {
        dock = lib.mkDefault "bottom";
      };

      # Privacy
      edit_predictions = {
        allow_data_collection = lib.mkDefault "no";
        disabled_globs = [
          "**/*.cert"
          "**/*.crt"
          "**/*.env*"
          "**/*.key"
          "**/*.pem"
          "**/*.pfx"
          "**/*.p12"
          "**/*passphrase*"
          "**/*secret*.bak"
          "**/*secret*.conf"
          "**/*secret*.ini"
          "**/*secret*.json"
          "**/*secret*.jsonl"
          "**/*secret*.toml"
          "**/*secret*.yaml"
          "**/*secret*.yml"
          "**/secret/**"
          "**/secrets/**"
          "**/ssh/**"
        ];
      };
      telemetry = {
        diagnostics = lib.mkDefault false;
        metrics = lib.mkDefault false;
      };

      # https://zed.dev/docs/languages
      languages = {
        Markdown = {
          document_folding_ranges = lib.mkDefault "on";
          format_on_save = lib.mkDefault "off";
          hard_tabs = lib.mkDefault false;
          language_servers = [ "panache-language-server" ];
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

      # https://zed.dev/docs/configuring-languages
      lsp = {
        # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
        nixd.settings.nixd.formatting.command = [ "nixfmt" ];
        package-version-server.binary.path = lib.mkDefault "package-version-server";
        # https://panache.bz/guide/lsp.html
        panache-language-server.binary = {
          path = lib.mkDefault "panache";
          arguments = [ "lsp" ];
        };
      };
    };

    # https://zed.dev/docs/key-bindings
    # https://zed.dev/docs/all-actions
    # Disable/Unbind keymaps:
    #  - "keymap" = null; -> disable keymap in a specific context
    #  - unbind = {"keymap" = "action"}; -> disable keymap in a specific context for a specific action
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-#" = [
            "editor::ToggleComments"
            { advance_downwards = true; }
          ];
          "ctrl-*" = "editor::UnfoldAll";
          "ctrl-_" = "editor::FoldAll";
          "ctrl-alt-g" = "editor::SplitSelectionIntoLines";
          "ctrl-shift-+" = "editor::UnfoldAll";
          "ctrl-shift--" = "editor::FoldAll";
          "ctrl-y" = "editor::Redo";
        };
      }
      {
        context = "Editor && mode == full";
        bindings = {
          "ctrl-alt-w" = "editor::ToggleSoftWrap";
        };
      }
      {
        context = "Workspace";
        unbind = {
          "ctrl-k" = "git_panel::ToggleFocus";
        };
      }
    ];
  };
}
