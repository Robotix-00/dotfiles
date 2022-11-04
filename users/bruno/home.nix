{ pkgs, config, ... }:
{
  home = {
    username = "bruno";
    homeDirectory = "/home/bruno";
    stateVersion = "22.05";

    packages = [];

    file = {
      # ".config/xmonad/".source = ./../../dotfiles/xmonad;   # set to manual, active development
      # ".config/ranger/".source = ./../../dotfiles/ranger;   # set to manual, doesnt work because confdir has to be writable
      ".tmux.conf".source = ./../../dotfiles/tmux.conf;
    };
  };

  programs = {
    home-manager.enable = true;


    git = {
      enable = true;
      userName = "Bruno Hoffmann";
      userEmail = "0xbruno.hoffmann@gmail.com";
    };
  };

  services = {
    xscreensaver.enable = true;

    gpg-agent = {
      enable = true;
      # enableZshIntegration = true;
    };
  };

  gtk = {
    enable = true;
    
    font = {
      name = "Fira Code";
      package = pkgs.fira-code;
    };

    theme = {
      name = "SolArc-Dark";
      package = pkgs.solarc-gtk-theme;
    };

    # doesn't work
    # cursorTheme = {
    #   name = "Capitaine-cursors";
    #   package = pkgs.capitaine-cursors;
    # };
  };
}
