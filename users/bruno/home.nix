{ pkgs, config, ... }:
{
  home = {
    username = "bruno";
    homeDirectory = "/home/bruno";
    stateVersion = "22.05";

    packages = [];
  };
  programs.home-manager.enable = true;


  programs.git = {
    enable = true;
    userName = "Bruno Hoffmann";
    userEmail = "0xbruno.hoffmann@gmail.com";
  };

  gtk = {
    enable = true;
    font.name = "Fira Code";
    theme = {
      name = "SolArc-Dark";
      package = pkgs.solarc-gtk-theme;
    };
    # cursorTheme = {
    #   name = "bibata-cursors";
    #   package = pkgs.bibata-cursors;
    # };
  };


  home.file = {
    # ".config/xmonad/".source = ./../../dotfiles/xmonad;   # set to manual
    ".config/ranger/".source = ./../../dotfiles/ranger;
    ".tmux.conf".source = ./../../dotfiles/tmux.conf;
  };
}
