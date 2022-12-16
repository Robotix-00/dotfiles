{pkgs, lib, ...}:
{
  imports = [
    ./bluetooth.nix
    ./ssh.nix
  ];

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 ];
    # allowedUDPPorts = [ ... ];
  };

  networking.useDHCP = lib.mkDefault true;
}
