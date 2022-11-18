{ pkgs, lib, isDesktop, ...}:
{
  environment.systemPackages = with pkgs; [
    ranger
    odt2txt pandoc
  ] ++ lib.optionals isDesktop [
    ueberzug poppler_utils
  ];
}
