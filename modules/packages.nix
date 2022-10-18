{pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # CLI tools
    wget
    git
    qemu
    neofetch
    htop
    neofetch
    bat
    tmux
    tree
    tldr          # like man but with examples
    cmatrix       # if i'm bored
    imagemagick   # to convert images

    nix-index

    # system utility
    usbutils
    pciutils
    inetutils
    alsa-utils
    wirelesstools
    iw
    unzip
    killall


    # terminal emulators
    alacritty
    rxvt-unicode

    # programming
    python310
    conda

    platformio

    # GUI tools
    firefox
    brave
    thunderbird
    discord
    spotify

    dconf # so libreoffice can work
    libreoffice
    joplin-desktop


    feh         # image viewer
    evince      # pdf viewer
    ranger      # file viewer
    ueberzug    # image viewer for terminal
    vlc         # video player
  ];
}
