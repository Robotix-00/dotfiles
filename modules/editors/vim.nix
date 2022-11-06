{ pkgs, lib, ... }:
let
  # nixpks version doesn't work, use manual
  vim-better-whitespace = pkgs.vimUtils.buildVimPlugin {
    name = "vim-better-whitespace";
    src = pkgs.fetchFromGitHub {
      owner = "ntpeters";
      repo = "vim-better-whitespace";
      rev = "1b22dc57a2751c7afbc6025a7da39b7c22db635d";
      sha256 = "10l01a8xaivz6n01x6hzfx7gd0igd0wcf9ril0sllqzbq7yx2bbk";
    };
  };

  vim-better-comments = pkgs.vimUtils.buildVimPlugin {
    name = "vim-better-comments";
    src = pkgs.fetchFromGitHub {
      owner = "jbgutierrez";
      repo = "vim-better-comments";
      rev = "39f92579dd0ffb6e199e398f590aeb1480e96558";
      sha256 = "sha256-R6XcT9ygBnAHjnybjxkabna8x9W1LJJN1DzwzqteQo0=";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    defaultEditor = true;

    configure = {
      customRC = ''
        set termguicolors
        set number

        setlocal foldmethod=marker
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          nerdtree          # file navigation
          # nvim-fzf          # file navigation
          vim-commentary
          indentLine
          vim-visual-multi  # multi line edits

          vim-gitgutter

          ale
          vim-autoformat

          # language specific
          vim-nix
          vim-polyglot
          vim-markdown
          markdown-preview-nvim

          # visual
          vim-better-comments
          vim-better-whitespace
          vim-devicons
          syntastic
          rainbow
          lightline-vim
        ];
        opt = [];
      };
    };
  };
}
