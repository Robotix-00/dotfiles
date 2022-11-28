{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    enableOnBoot = false;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
