{ pkgs, ... }:
{
  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    lutris-free
    winetricks
    wineWowPackages.stable
  ];
}
