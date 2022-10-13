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
    cursorTheme.name = "Nordzy-cursors";
  };


  # xmonad config
  home.file.".config/xmonad/xmonad.hs".source = ./../../dotfiles/xmonad.hs;
  home.file.".config/xmonad/xmobarrc".source = ./../../dotfiles/xmobarrc;

  # tmux
  home.file.".tmux.conf".source = ./../../dotfiles/tmux.conf;
}
