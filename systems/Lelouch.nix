{config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      ./base.nix
    ];

  networking.hostName = "Lelouch"; # Define your hostname.

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/83ee16bd-d31b-4003-938a-f2b84ac04695";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/6E32-B564";
      fsType = "vfat";
    };

  swapDevices = [ ];

  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    middleEmulation = true;
    tapping = true;
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
