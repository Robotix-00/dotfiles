{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
  };
}
