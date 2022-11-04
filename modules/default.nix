{ pkgs, lib, isDesktop, ... }:
{
  imports = [
    ./packages.nix
    ./editors/vim.nix
    ./docker.nix
    ./gpg.nix

    ./shells
  ] ++ lib.optionals isDesktop [
    ./audio.nix

    ./visual/desktop.nix
    ./visual/fonts.nix
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
      packages = with pkgs; [
      ];
    };
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
