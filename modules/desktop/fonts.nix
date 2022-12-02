{ pkgs, ... }:
{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      # (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })
      nerdfonts
      fira-code
      fira-code-symbols
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Fira Code" ];
        monospace = [ "Fira Code" ];
      };
    };
  };
}
