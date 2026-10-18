{
  pkgs,
  ...
}:
{
  # https://wiki.nixos.org/wiki/Gaming
  imports = [
    ./mangohud.nix
  ];

  home = {
    packages = with pkgs; [
      # Heroic Games Launcher
      heroic

      # Lutris
      lutris

      # Wine: https://wiki.nixos.org/wiki/Wine
      # Wow64: Windows on Windows 64-bit (handles both 32bit and 64bit Windows apps)
      wineWow64Packages.staging # compatibility layer (engine) with staging patches
      # Experimental native Wayland engine
      # wineWow64Packages.waylandFull # curently, worse game compatibility than staging
      winetricks # quickly download and configure DLLs for Wine (e.g. WebView2)

      # Proton
      protontricks # winetricks wrapper for proton enabled games
      protonup-qt # widely used program to manage Proton-GE
      #protonplus # newer alternative to protonup-qt

      # Launch option: gamescope %command%
      #gamescope
    ];
  };
}
