{ pkgs, lib, isDesktop, ...}:
{
  environment.systemPackages = with pkgs; [
    ranger  # ranger itself
    pandoc  # html, markdown
    odt2txt # odt, ods
    jq      # json
  ] ++ lib.optionals isDesktop [
    ueberzug            # X11 renderer
    poppler_utils       # pdf
    ffmpegthumbnailer   # video
  ];
}
