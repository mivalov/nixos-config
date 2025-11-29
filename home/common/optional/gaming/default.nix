{
  pkgs,
  ...
}:
{
  imports = [
    ./mangohud.nix
  ];

  home = {
    packages = with pkgs; [
      heroic # Heroic Games launcher
      lutris
      protonup-qt # widely used program to manage Proton-GE
      #protonplus  # newer alternative to protonup-qt
      # Launch option: gamescope %command%
      #gamescope
    ];
  };
}
