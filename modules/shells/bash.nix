{ pkgs, ... }:
{
  programs.bash = {
    enableCompletion = true;
    enableLsColors = true;
  };
}
