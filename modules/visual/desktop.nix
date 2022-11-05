{ pkgs, self, ... }:
{ 
 # desktop/display/login
  services = {
    xserver = {
      enable = true;
      layout = "de";
      xkbOptions = ""; #TODO

      displayManager.sessionCommands = "
      xset -dpms
      # xset s off
      ";

      displayManager.lightdm = {
        enable = true;
        background = "${self}/assets/bootscreen.jpg";
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages : with haskellPackages; [
          xmonad-contrib
          xmonad-extras
          xmonad
        ];
    };
   };
 };
   environment.systemPackages = with pkgs; [
    dmenu       # search menu
    # nitrogen    # background
    feh         # background and images
    xmobar      # task bar
    pstree      # so window swallowing works for xmonad
  ];


  services.picom = {
    enable = true;
    fade = true;
  };
}
