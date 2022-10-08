{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
  };

  environment.systemPackages = with pkgs.fishPlugins; [
  ] ++ [
    pkgs.oh-my-fish
  ];
}
