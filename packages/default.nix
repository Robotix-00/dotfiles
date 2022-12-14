{ pkgs, stable, lib, isDesktop, ... }:
{
  imports = [
    ./zsh
    ./vim
    ./kitty

    ./tmux
    ./ranger

    ./lutris
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # system utility
    usbutils
    pciutils
    nix-index
    nix-tree
    tldr          # similar to man-pages
    cheat
    neofetch
    ipfetch

    #network util
    wirelesstools
    inetutils
    iw

    # file management
    git
    git-secret

    gource  # git visualisation tool
    unzip
    wget
    tree
    bat

    ripgrep

    # processes
    htop
    killall
    qemu

    cmatrix
    cbonsai  # if i'm bored
    figlet

    # programming
    python310
    conda
    platformio

    wineWowPackages.stable
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

    # images
    feh         # image viewer
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
}
