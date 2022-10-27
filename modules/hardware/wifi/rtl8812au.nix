{ pkgs, config, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8812au
  ];
  boot.initrd.kernelModules = [ "8812au" ];
}
