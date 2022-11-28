{ pkgs, config, lib, self, isDesktop, grub-themes, ... }:
{
  imports =
    [
      ./../modules
      ./../modules/bluetooth.nix

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

      extraConfig = ''
        set theme=${grub-themes.cyberpunk}
      '';
    };
  };

  # define hostname
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "22.05";
}
