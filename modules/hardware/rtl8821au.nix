{ pkgs, config, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8821au
    rtl8812au
  ];
  boot.initrd.kernelModules = [ "8821au" "8812au" ];
}
