{ pkgs, config, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8821au
  ];
  boot.initrd.kernelModules = [ "8821au" ];
}
