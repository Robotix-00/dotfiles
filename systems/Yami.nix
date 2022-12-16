{config, lib, pkgs, ... }:

{
  imports =
    [
      ./base.nix
    ];

  networking.hostName = "Yami"; # Define your hostname.

  boot.supportedFilesystems = [ "ntfs" ];
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

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  services.xserver.libinput = {
    enable = true;
	touchpad = {
    naturalScrolling = true;
    middleEmulation = true;
    tapping = true;
	};
  };
}
