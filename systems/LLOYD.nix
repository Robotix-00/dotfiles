{ config, hardware, grub-themes, ... }:
{
  imports =
    [
      ./../modules/hardware/tello.nix

      ./../packages/vscode

    ] ++ (with hardware; [
      common-cpu-intel
      common-gpu-nvidia-nonprime
      common-pc
      common-pc-hdd
      common-pc-ssd
    ]);

  # adding windows dual boot
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

  # hardware stuff
  hardware.ckb-next = {
    enable = true;
    gid = 100;
  };

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];


  # device specific mount-points
  fileSystems."/" =
      { device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };

  fileSystems."/nix/store" =
    { device = "/nix/store";
      fsType = "none";
      options = [ "bind" ];
    };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
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
