with (import <nixpkgs>{});
stdenv.mkDerivation {
    pname = "assets";
    version = "0.0.1";
    src = ./.;
    installPhase = ''
       cp -r ./ $out/
    '';
}
