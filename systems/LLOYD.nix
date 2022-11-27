{ pkgs, config, lib, self, isDesktop, grub-themes, ... }:
{
  imports =
    [
      ./../modules
      ./../modules/bluetooth.nix

      ./../modules/hardware/printing.nix
      ./../modules/hardware/corsair.nix

      ./../modules/hardware/wifi/rtl8821au.nix
      ./../modules/hardware/wifi/rtl8812au.nix
    ] ++ lib.optionals isDesktop [
      ./../packages/vscode
    ];

  # Bootloader
  boot.supportedFilesystems = [ "ntfs" ];
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

      extraEntries = ''
        menuentry 'Windows' --class windows --class os $menuentry_id_option 'osprober-efi-293A-451F' {
                insmod part_gpt
                insmod fat
                set root='hd1,gpt1'
                if [ x$feature_platform_search_hint = xy ]; then
                  search --no-floppy --fs-uuid --set=root --hint-bios=hd1,gpt1 --hint-efi=hd1,gpt1 --hint-baremetal=ahci1,gpt1  293A-451F
                else
                  search --no-floppy --fs-uuid --set=root 293A-451F
                fi
                chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  # define hostname
  networking.hostName = "LLOYD";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # video drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # hardware stuff
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];


  # device specific mount-points
  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/293A-451F";
      fsType = "vfat";
    };

  # mount mass storage drive in user space
  fileSystems."/home/bruno/projects" = {
    device = "dev/disk/by-label/Data";
    fsType = "ext4";
  };

  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "22.05";
}
