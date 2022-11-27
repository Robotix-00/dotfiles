{ pkgs, config, ... }:
let
  nordzyCursors = pkgs.fetchFromGitHub {
    owner = "alvatip";
    repo = "Nordzy-cursors";
    rev = "2afc440070703da0c77ad9b0b13fd2701dbda1df";
    sha256 = "sha256-MRNtxaFg0oLoWGo7WJGfnEPcj2bUQg3rAD1ZisyyZpg=";
  };
in
{
  home = {
    username = "bruno";
    homeDirectory = "/home/bruno";
    stateVersion = "22.05";

    packages = [];

    file = {
      ".config/xmonad/".source = ./../../modules/desktop/xmonad/config;   # set to manual, active development
      # ".config/ranger/".source = ./../../packages/ranger/config;   # set to manual, doesnt work because confdir has to be writable
      ".config/kitty/".source = ./../../packages/kitty/config;
      ".tmux.conf".source = ./../../packages/tmux/tmux.conf;
      ".zshrc".source = ./../../packages/zsh/zshrc;

      # cursor
      ".icons/default".source = "${nordzyCursors}/Nordzy-cursors";
    };
  };

  programs = {
    home-manager.enable = true;

    # stupid that i have to do this in home manager
    neovim.plugins = [
      pkgs.nvim-treesitter.withAllGrammars
    ];

    git = {
      enable = true;
      userName = "Bruno Hoffmann";
      userEmail = "0xbruno.hoffmann@gmail.com";
    };
  };

  services = {
    xscreensaver.enable = true;

    gpg-agent = {
      enable = true;
      # enableZshIntegration = true;
    };
  };

  gtk = {
    enable = true;

    font = {
      name = "Fira Code";
      package = pkgs.fira-code;
    };

    theme = {
      name = "SolArc-Dark";
      package = pkgs.solarc-gtk-theme;
    };
  };
}
