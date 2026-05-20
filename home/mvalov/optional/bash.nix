{
  config,
  lib,
  pkgs,
  ...
}:
let
  #inherit (lib) mkOption types;
  # Path to git-prompt.sh
  gitPromptPath = builtins.toPath "${pkgs.git}/share/git/contrib/completion/git-prompt.sh";

  cfg = config.features.bash;

  # Default PS1 (expanded at runtime in bash; escape)
  defaultPS1 = lib.concatStrings [
    ''''${RESET}\[\e]0;\u@\h: \w\a\]''
    ''''${BRIGHT_GREEN}\u@\H''
    "\${RESET}:"
    ''''${BRIGHT_BLUE}\w''
    ''''${RESET}:$(git_branch_status)\n\\$ ''
  ];

  # ANSI escape themes
  ansi_themes = {
    cyan = {
      md = "1;36"; # headers: bold cyan
      us = "1;4;32"; # vars/paths: bold underline green
      so = "1;30;43"; # search/status: bold black on yellow background
      mb = "1;35"; # blink/warnings: bold magenta
    };
    red = {
      md = "1;31"; # headers: bold red
      us = "1;4;33"; # vars/paths: bold underline yellow
      so = "1;30;42"; # search/status: bold black on green background
      mb = "1;35"; # blink/warnings: bold magenta
    };
    white = {
      md = "1;37"; # headers: bold white
      us = "1;4;37"; # vars/paths: bold underline white
      so = "7"; # search/status: reverse video (black on white background)
      mb = "1;37"; # blink/warnings: bold white
    };
  };

  ansi_theme = ansi_themes.${cfg.coloredManPages.theme};
in
{
  options.features.bash = {
    ps1 = lib.mkOption {
      type = lib.types.str;
      default = defaultPS1;
      description = ''
        The PS1 string used by the custom prompt.
        Variables like ''${GREEN} and command substitution are expanded at runtime by bash.
      '';
    };

    gitPrompt = {
      # https://mtlynch.io/notes/nix-git-bash-shell/
      # https://jeffkreeftmeijer.com/nix-home-manager-git-prompt/
      # https://unix.stackexchange.com/questions/686346/how-to-keep-ps1-when-using-nix-shell
      showDirtyState = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables GIT_PS1_SHOWDIRTYSTATE, which adds *,+ when dirty/staged.";
      };
      showStashState = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables GIT_PS1_SHOWSTASHSTATE, which adds $ when stash entries exist.";
      };
      showUntrackedFiles = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables GIT_PS1_SHOWUNTRACKEDFILES, which adds % when untracked files exist.";
      };
      showUpstream = lib.mkOption {
        type = lib.types.str;
        default = ""; # accepts "", "auto", "git", etc.
        description = "Sets GIT_PS1_SHOWUPSTREAM=auto, which adds =/>/< for sync/ahead/behind.";
      };
      colorDirty = lib.mkOption {
        type = lib.types.str;
        default = "BRIGHT_YELLOW";
        description = "Bash color variable used for a dirty git branch state.";
      };
      colorClean = lib.mkOption {
        type = lib.types.str;
        default = "BRIGHT_GREEN";
        description = "Bash color variable used for a clean git branch state.";
      };
    };

    coloredManPages = {
      # https://www.youtube.com/watch?v=D0sG2fj0G4Y
      # https://gist.github.com/bahamas10/542875bb47990933638d2b7dfaa501bf
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Adds colors to manual pages.";
      };
      theme = lib.mkOption {
        type = lib.types.enum [
          "cyan"
          "red"
          "white"
        ];
        default = "cyan";
        description = "Color theme to use for manual pages.";
      };
    };
  };

  config = {
    programs.bash = {
      enable = true;
      enableCompletion = lib.mkDefault true;
      historyControl = lib.mkDefault [ "ignoreboth" ];
      historyFileSize = lib.mkDefault 50000;
      historySize = lib.mkDefault 5000;
      shellAliases = {
        ll = lib.mkDefault "ls -laFh";
        ".." = lib.mkDefault "cd ..";
      };
      #shellOptions = lib.mkDefault [];

      initExtra = ''
        ${
          if config.features.bash.coloredManPages.enable then
            ''
              # Disable groff SGR for better color control
              #export GROFF_NO_SGR=1
              # Alternative, but only restricted to man
              # https://bbs.archlinux.org/viewtopic.php?id=287185
              export MANROFFOPT=-c

              # Define custom colors for man pages (man terminfo/tput)
              # Start blinking mode (often used for special warnings)
              export LESS_TERMCAP_mb=$'\e[${ansi_theme.mb}m'
              # Start bold mode (section headers and command names)
              export LESS_TERMCAP_md=$'\e[${ansi_theme.md}m'
              # Start standout mode (search results and the bottom status bar)
              export LESS_TERMCAP_so=$'\e[${ansi_theme.so}m'
              # Start underline mode (usually for variables and file paths)
              export LESS_TERMCAP_us=$'\e[${ansi_theme.us}m'

              # End all special formatting (reset color/bold/underline back to normal)
              export LESS_TERMCAP_me=$'\e[0m'
              # End standout mode (reset search highlight/status bar)
              export LESS_TERMCAP_se=$'\e[0m'
              # End underline mode (reset the underline effect)
              export LESS_TERMCAP_ue=$'\e[0m'

              # Start reverse-video mode (swaps foreground and background colors)
              export LESS_TERMCAP_mr=$'\e[7m'
              # Start dim/half-bright mode (dims the text color)
              export LESS_TERMCAP_mh=$'\e[2m'

              # Wire up `man` to use `less` (usually the default)
              export MANPAGER='less'
            ''
          else
            ""
        }
        # Load __git_ps1 bash command
        if [ -r ${gitPromptPath} ]; then
          . ${gitPromptPath}
        fi

        # Colors (wrap nonprinting with \[ \] so readline counts width)
        RESET="\[\e[0m\]"
        BOLD="\[\e[1m\]"
        RED="\[\e[1;31m\]"
        GREEN="\[\e[1;32m\]"
        YELLOW="\[\e[1;33m\]"
        BLUE="\[\e[1;34m\]"
        MAGENTA="\[\e[1;35m\]"
        CYAN="\[\e[1;36m\]"
        BRIGHT_RED="\[\e[1;91m\]"
        BRIGHT_GREEN="\[\e[1;92m\]"
        BRIGHT_YELLOW="\[\e[1;93m\]"
        BRIGHT_BLUE="\[\e[1;94m\]"
        BRIGHT_MAGENTA="\[\e[1;95m\]"
        BRIGHT_CYAN="\[\e[1;96m\]"

        # Configure what __git_ps1 shows from given options
        # When enabled, adds *,+ when dirty/staged
        GIT_PS1_SHOWDIRTYSTATE=${if config.features.bash.gitPrompt.showDirtyState then "1" else ""}
        # When enabled, adds $ when stash entries exist
        GIT_PS1_SHOWSTASHSTATE=${if config.features.bash.gitPrompt.showStashState then "1" else ""}
        # When enabled, adds % when untracked files exist
        GIT_PS1_SHOWUNTRACKEDFILES=${if config.features.bash.gitPrompt.showUntrackedFiles then "1" else ""}
        # When enabled, adds =/>/< for sync/ahead/behind
        GIT_PS1_SHOWUPSTREAM=${lib.escapeShellArg config.features.bash.gitPrompt.showUpstream}

        function git_branch_status() {
          git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0
          if [ -z "$(git status --porcelain 2>/dev/null)" ]; then
            printf '%s' "''${${lib.toUpper config.features.bash.gitPrompt.colorClean}}$(__git_ps1 '(%s)')''${RESET}"
          else
            printf '%s' "''${${lib.toUpper config.features.bash.gitPrompt.colorDirty}}$(__git_ps1 '(%s)')''${RESET}"
          fi
        }

        # default PS1
        #PROMPT_COLOR="1;32m"  # bold green
        #PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "

        # custom PS1 - two-line promt:
        # [user@host:/cwd] (branch)
        # $ command
        #PS1="''${BRIGHT_RED}[\[\e]0;\u@\h: \w\a\]''${GREEN}\u''${YELLOW}@''${BRIGHT_BLUE}\H''${YELLOW}:''${BRIGHT_MAGENTA}\w''${BRIGHT_RED}]''${RESET}$(git_branch_status)\n\\$ "

        _hm_build_ps1() {
          PS1="${config.features.bash.ps1}"
        }

        # Append to PROMPT_COMMAND so __vte_prompt_command still runs
        if [ -n "''${PROMPT_COMMAND-}" ]; then
          PROMPT_COMMAND="_hm_build_ps1; ''${PROMPT_COMMAND}"
        else
          PROMPT_COMMAND="_hm_build_ps1"
        fi
      '';
    };
  };
}
