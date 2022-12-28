{ pkgs, ... }:
{
  networking.firewall.allowedUDPPorts = [ 8889 8890 11111 ];

  environment.systemPackages = with pkgs; [
    conda
  ];
}
