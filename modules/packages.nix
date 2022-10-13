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
    tldr    # like man but with examples
    cmatrix

    nix-index

    # system utility
    usbutils
    pciutils
    inetutils
    alsa-utils
    wirelesstools
    iw


    # terminal emulators
    alacritty
    kitty

    # programming
    python310
    python38
    conda
    glib

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


    feh # image viewer
    evince # pdf viewer
  ];
}
