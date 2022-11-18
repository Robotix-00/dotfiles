{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    shortcut = "a";

    keyMode = "vi";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      nord      # theme
      tmux-fzf  # fuzzy finder
      vim-tmux-navigator
    ];
  };
}

