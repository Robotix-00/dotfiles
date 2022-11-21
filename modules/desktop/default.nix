{ pkgs, self, ...}:
{
  imports = [
    ./fonts.nix
    ./xmonad
  ];

  services = {
    xserver = {
      enable = true;
      layout = "de";
      xkbOptions = ""; #TODO

      displayManager.sessionCommands = "
      xset -dpms
      ";

      displayManager.lightdm = {
        enable = true;
        background = "${self}/assets/bootscreen.jpg";
      };
    };
  };
}

