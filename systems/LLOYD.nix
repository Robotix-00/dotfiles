{ pkgs, config, lib, self, ... }:
{
  imports =
    [
      ./../modules
      ./../modules/bluetooth.nix
      
      ./../modules/hardware/printing.nix
      ./../modules/hardware/corsair.nix

      ./../modules/hardware/wifi/rtl8821au.nix
      ./../modules/hardware/wifi/rtl8812au.nix

      ./../modules/shells/fish.nix
      ./../modules/shells/zsh.nix
      ./../modules/shells/tmux.nix
    ];
  users.defaultUserShell = pkgs.zsh;

  nix.package = pkgs.nixUnstable;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader. 
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

      darkmatter-theme = {
        enable = true;
        style = "nixos";
        icon = "color";
        resolution = "1440p";
      };

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

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e37c33a8-e178-42ae-9431-a617b0d73717";
      fsType = "ext4";
    };

  fileSystems."/nix/store" =
    { device = "/nix/store";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/293A-451F";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/169130e0-3ea6-46b8-89c9-d21c73af5608"; }
    ];
 
  # mount mass storage drive in user space
  fileSystems."/home/bruno/Data" = {
    device = "dev/disk/by-label/Data";
    fsType = "ext4";
  };

  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "22.05";
}
