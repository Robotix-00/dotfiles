{pkgs, ...}:
let
  cyberpunkPkg = pkgs.fetchFromGitHub {
    owner = "anoopmsivadas";
    repo = "Cyberpunk-GRUB-Theme";
    rev = "1efd2cd4a1f82e5809e494d1c8b7b31fdbd1f3d0";
    sha256 = "sha256-UlO3/KvfBbRc6FTFREmhmduQLrXlyJwZh6ufRtgFEK0=";
  };
in
{
  cyberpunk = "${cyberpunkPkg}/Cyberpunk/theme.txt";
}
