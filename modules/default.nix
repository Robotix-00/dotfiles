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
      extraGroups = [ "audio" "networkmanager" "wheel" "docker" ];
    };
  };

  environment.sessionVariables = rec {
    DOTFILES  = "/home/bruno/.dotfiles";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.utf8";
}
