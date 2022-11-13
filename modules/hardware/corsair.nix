{ pkgs, ... }:
{
  hardware.ckb-next.enable = true;

  # zu faule ne neue datei zu machen, ist halt logitech
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
}
