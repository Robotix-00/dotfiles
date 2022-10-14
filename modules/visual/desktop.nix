{ pkgs, self, ... }:
{ 
 # desktop/display/login
  services = {
    xserver = {
      enable = true;
      displayManager.lightdm = {
        enable = true;
        background = "${self}/assets/bootscreen.jpg";
      };
      desktopManager.xterm.enable = false;

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
    nitrogen    # background
    xmobar      # task bar
    pstree      # so window swallowing works for xmonad
  ];


  services.picom = {
    enable = true;
    fade = true;
  };
}
