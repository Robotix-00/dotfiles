{ pkgs, config, lib, isDesktop, ... }:
{
  imports =
    [
      ./../modules
    ] ++ lib.optionals isDesktop [
    ];

  services.tlp.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];

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
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  system.stateVersion = "22.11";
}
