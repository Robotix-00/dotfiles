{ pkgs, lib, isDesktop, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # system utility
    usbutils
    pciutils      
    nix-index
    tldr          # similar to man-pages    
    cheat
    neofetch

    #network util
    wirelesstools
    inetutils     
    iw

    # file management
    vim
    git
    unzip
    wget
    tree
    bat
    ranger
    ripgrep
    peco

    # processes
    htop
    killall 
    qemu
    docker
    docker-compose
    
    cmatrix
    cbonsai  # if i'm bored
    figlet

    # programming
    python310
    conda
    platformio

  ] ++ lib.optionals isDesktop [
    # Desktop applications

    # terminal emulators
    alacritty
    kitty

    # office
    libreoffice dconf # so libreoffice can work
    evince            # pdf viewer
    thunderbird       # email client
    joplin-desktop    # note-taking software
    languagetool

    # images
    feh         # image viewer
    ueberzug    # image viewer for terminal
    vlc         # video player
    flameshot   # screenshots
    gimp        # image procesing
    imagemagick # to convert images

    # GUI tools
    firefox
    brave

    discord
    spotify    
  ];

  virtualisation.docker.enable = true;
}
