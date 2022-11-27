{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin
      "refresh-background"
      "feh ${./background} --randomize --bg-fill"
    )
  ];
}

