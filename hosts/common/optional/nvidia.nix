{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
  cfg = config.features.nvidia;
in
{
  # https://nixos.org/manual/nixos/stable/
  # https://wiki.nixos.org/wiki/Graphics
  # https://wiki.nixos.org/wiki/NVIDIA
  # https://nixos.wiki/wiki/Nvidia

  # Options
  options.features.nvidia = {
    enable = mkEnableOption "Enable NVIDIA GPU support";

    igpu = {
      type = mkOption {
        type = types.enum [
          "intel"
          "amd"
          "none"
        ];
        default = "intel";
        description = ''
          Type of integrated GPU:
            - "intel": Intel iGPU
            - "amd": AMD iGPU
            - "none": no iGPU or not used
        '';
      };
      busId = mkOption {
        type = types.str;
        default = "";
        example = "PCI:0:2:0";
        description = ''
          PCI bus ID of the integrated GPU (iGPU), in "PCI:BUS:DEVICE:FUNCTION" format.
          Get it via: lspci | grep -i 'vga'
          alternatively: nix run nixpkgs#pciutils -- -mm | grep -i vga
        '';
      };
    };

    # Choose PRIME mode for hybrid laptops (Intel/AMD + NVIDIA)
    primeMode = mkOption {
      type = types.enum [
        "offload"
        "sync"
        "none"
      ];
      default = "offload";
      description = ''
        PRIME mode for hybrid systems:
          - "offload": Intel/AMD is primary, NVIDIA only when explicitly offloaded.
          - "sync": NVIDIA renders everything (better for tearing/Wayland, higher power).
          - "none": disable PRIME config (desktop with only NVIDIA, or iGPU disabled)
      '';
    };

    nvidiaBusId = mkOption {
      type = types.str;
      default = "";
      example = "PCI:1:0:0";
      description = ''
        PCI bus ID of the NVIDIA GPU, in "PCI:BUS:DEVICE:FUNCTION" format.
        Get it via: lspci | grep -i 'vga'
        alternatively: nix run nixpkgs#pciutils -- -mm | grep -i vga
      '';
    };

    # Which kernel module flavor to use
    driver = {
      # For Turing architecture you can usually use the open module.
      open = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Use NVIDIA's "open" kernel module (true) or the proprietary one (false).
          Since driver version 560, the option must be explicitly set.
          Make sure to allow unfree software even when using the open module
          as the user space part is still proprietary.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Xorg driver choice depends on the PRIME mode
    services.xserver.videoDrivers =
      if cfg.primeMode == "offload" then
        [
          (if cfg.igpu.type == "amd" then "amdgpu" else "modesetting")
          "nvidia"
        ]
      else
        [ "nvidia" ]; # sync/none: NVIDIA is primary

    hardware = {
      graphics = {
        # Usually defined by desktop environments
        enable = true;

        # 32-bit libs  (OpenGL/Vulkan) for older games, Wine, Steam, etc.
        enable32Bit = mkDefault true;
      };

      nvidia = {
        # Since driver version 560, must decide on open-source or proprietary modules
        # - for Turing generations -> use open kernel module
        # - for older GPUs override to false for that host
        open = cfg.driver.open;

        # Kernel modesetting (KMS), helpful for Wayland
        modesetting.enable = mkDefault true;

        # NVIDIA's GUI configuration tool
        nvidiaSettings = mkDefault true;

        # stable driver by default, could override for legacy drivers
        package = mkDefault config.boot.kernelPackages.nvidiaPackages.stable;

        powerManagement = {
          # useful for laptops
          enable = mkDefault true;
          # can cause resume/suspend issues or glitches
          finegrained = mkDefault false;
        };

        # Optimus PRIME config
        prime = mkIf (cfg.primeMode != "none") (mkMerge [
          {
            nvidiaBusId = cfg.nvidiaBusId;
          }

          # Route iGPU bus ID to the correct option
          (mkIf (cfg.igpu.type == "intel") {
            intelBusId = cfg.igpu.busId;
          })
          (mkIf (cfg.igpu.type == "amd") {
            amdgpuBusId = cfg.igpu.busId;
          })

          # Mode-specific bits
          (mkIf (cfg.primeMode == "offload") {
            offload.enable = true;
            offload.enableOffloadCmd = true;
          })
          (mkIf (cfg.primeMode == "sync") {
            sync.enable = true;
          })
        ]);
      };
    };
  };
}
