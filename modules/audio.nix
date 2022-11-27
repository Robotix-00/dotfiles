{ pkgs, ... }:
{
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    extraConfig = "load-module module-combine-sink";
  };

  environment.systemPackages = with pkgs; [
    alsa-lib alsa-plugins alsa-utils
  ];
}
