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
    # nitrogen    # background
    feh         # background and images
    xmobar      # task bar
    pstree      # so window swallowing works for xmonad
  ];


  services.picom = {
    enable = true;
    fade = true;
    # experimentalBackends = true;

    # settings = {
    #   rounded-borders = 1;
    #   corner-radius = 4;
    #    corner-radius-exclude = [
    #      "WM_NAME" = "xmobar"
    #    ];
    # };
  };
}
