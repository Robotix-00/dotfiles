{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;

    terminal = "tmux-256color";
    #extraConfig = (builtins.readFile ./../../../dotfiles/.tmux.conf);
  };
}

