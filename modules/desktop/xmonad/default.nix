{ pkgs, self, ... }:
{
 # desktop/display/login
  services = {
    xserver = {
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
    feh         # background and images
    xmobar      # task bar
    pstree      # so window swallowing works for xmonad
    gnome.zenity# text displaying for keybinds
  ];


  services.picom = {
    enable = true;
    fade = true;
  };
}
