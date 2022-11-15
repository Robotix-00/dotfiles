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

  vim-hexedit = pkgs.vimUtils.buildVimPlugin {
    name = "vim-hexedit";
    src = pkgs.fetchFromGitHub {
      owner = "rootkiter";
      repo = "vim-hexedit";
      rev = "174dd836d49b0bd785647f0730ad4f98ad101377";
      sha256 = "sha256-tniUeTt9odzHHFTIcPPbVstnQMBcHvWA1FMrr9vj/TA=";
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
        set relativenumber
        set foldmethod=marker

        colorscheme nightfox
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          nerdtree          # file navigation
          telescope-nvim
          # nvim-fzf          # file navigation
          vim-commentary
          indentLine
          vim-visual-multi  # multi line edits

          ale
          vim-autoformat

          # language specific
          vim-nix
          vim-polyglot
          vim-markdown
          markdown-preview-nvim

          # visual
          vim-devicons
          syntastic
          rainbow
          lightline-vim
          nightfox-nvim
        ] ++ [
          vim-better-comments
          vim-better-whitespace
          vim-hexedit
        ];

        opt = [
          vim-gitgutter
        ];
      };
    };
  };
}
