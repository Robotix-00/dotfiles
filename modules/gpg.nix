{ pkgs, stable, ... }:
{
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  environment.systemPackages = with pkgs; [
    stable.gnupg
  ];
}
