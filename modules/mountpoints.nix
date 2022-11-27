{...}:
{
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
}
