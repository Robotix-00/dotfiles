{ pkgs, self, ...}:
{
  imports = [
    ./fonts.nix
    ./xmonad
  ];

  hardware.opengl.enable = true;

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

