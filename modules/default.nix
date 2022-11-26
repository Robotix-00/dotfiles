{ pkgs, lib, isDesktop, ... }:
{
  imports = [
    ./../packages
    ./docker.nix
    ./gpg.nix
    ./ssh.nix

  ] ++ lib.optionals isDesktop [
    ./audio.nix

    ./desktop
  ];

  nix = {
    package = pkgs.nixUnstable;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Define a user account.
  users = {
    defaultUserShell = pkgs.zsh;

    users.bruno = {
      isNormalUser = true;
      description = "bruno";
      initialPassword = "passwordo";
      extraGroups = [ "audio" "networkmanager" "wheel" "docker" ];
    };
  };

  environment.sessionVariables = rec {
    DOTFILES  = "/home/bruno/.dotfiles";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

 # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.utf8";
    LC_IDENTIFICATION = "de_DE.utf8";
    LC_MEASUREMENT = "de_DE.utf8";
    LC_MONETARY = "de_DE.utf8";
    LC_NAME = "de_DE.utf8";
    LC_NUMERIC = "de_DE.utf8";
    LC_PAPER = "de_DE.utf8";
    LC_TELEPHONE = "de_DE.utf8";
    LC_TIME = "de_DE.utf8";
  };
}
