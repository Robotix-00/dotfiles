{ config, grub-themes, ... }:
{
  imports =
    [
      ./base.nix

      ./../modules/hardware/corsair.nix

      ./../modules/hardware/wifi/rtl8821au.nix
      ./../modules/hardware/wifi/rtl8812au.nix

      ./../packages/vscode
    ];

  # adding windows dual boot
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.grub.extraEntries = ''
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

  # define hostname
  networking.hostName = "LLOYD";

  # video drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # hardware stuff
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];


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
}
