{pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # system utility
    usbutils
    pciutils      
    alsa-utils    # audio
    nix-index
    tldr          # similar to man-pages    
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

    # processes
    htop
    killall 
    qemu
    
    cmatrix
    cbonsai  # if i'm bored


    # terminal emulators
    alacritty
    kitty

    # programming
    python310
    conda
    platformio

    # GUI tools
    firefox
    brave

    discord
    spotify


    # office
    libreoffice dconf # so libreoffice can work
    evince            # pdf viewer
    thunderbird       # email client
    joplin-desktop    # note-taking software
    
    # images
    feh         # image viewer
    ueberzug    # image viewer for terminal
    vlc         # video player
    flameshot   # screenshots
    gimp        # image procesing
    imagemagick # to convert images
  ];
}
