{ pkgs, stable, lib, isDesktop, ... }:
{
  imports = [
    ./zsh
    ./vim
    ./kitty

    ./tmux
    ./ranger
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
    vim
    git
    git-secret

    gource  # git visualisation tool
    unzip
    wget
    tree
    bat
    ranger
    odt2txt pandoc ueberzug poppler_utils # ranger util

    ripgrep
    peco

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
    languagetool

    # images
    feh         # image viewer
    vlc         # video player
    flameshot   # screenshots
    gimp        # image procesing
    imagemagick # to convert images

    # GUI tools
    firefox
    stable.brave

    discord
    spotify
  ];

  hardware.opengl.driSupport32Bit = true;
}
