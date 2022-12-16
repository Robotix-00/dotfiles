{ pkgs, lib, isDesktop, ... }:
{
  imports = [
 #   ./mountpoints.nix

    ./network
    ./virtualisation

    ./../packages
    ./../assets

    ./gpg.nix

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

  environment.systemPackages = [
    (pkgs.writeShellScriptBin
      "update"
      (builtins.readFile ./../update.sh)
    )
  ];

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

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
