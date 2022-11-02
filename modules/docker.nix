{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  environment.packages = with pkgs; [
    docker-compose
  ];
};
