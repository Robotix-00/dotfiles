{ pkgs, self, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin
      "refresh-background"
      "feh ${self}/assets/background --randomize --bg-fill"
    )
  ];
}

