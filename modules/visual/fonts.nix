{ pkgs, ... }:
{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
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
