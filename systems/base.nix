{ pkgs, config, lib, isDesktop, ... }:
{
  imports =
    [
      ./../modules

      ./../modules/hardware/printing.nix
    ] ++ lib.optionals isDesktop [
    ];

  # Bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;

      devices = [ "nodev" ];
      efiSupport = true;
      version = 2;
    };

    grub2-theme = {
      theme = "vimix";
      icon = "color";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  system.stateVersion = "22.11";
}
