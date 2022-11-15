{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      update = "/home/bruno/.dotfiles/update.sh";
      open = "xdg-open";
      ssh = "TERM=xterm-256color ssh";
    };
    enableCompletion = true;
    autosuggestions.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "man" "virtualenv" ];
      theme = "jbergantine";
    };
  };

  environment.systemPackages = with pkgs; [
    fzf
  ];
}
