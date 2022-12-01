{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      open = "xdg-open";
      ssh = "TERM=xterm-256color ssh";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    promptInit = builtins.readFile ./zshrc;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "man" "fzf" "thefuck" ];
    };
  };

  environment.systemPackages = with pkgs; [
    fzf
    zsh-fzf-tab
    thefuck
  ];
}
