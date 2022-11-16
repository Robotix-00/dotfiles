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
      customRC = builtins.readFile ./vimrc;

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          nerdtree          # file navigation
          telescope-nvim    # file fuzzy finding
          vim-commentary    # comment shortcuts
          indentLine        # shows lines for indent scopes
          vim-visual-multi  # multi line edits

          # generic coding
          YouCompleteMe     # code completion engine
          syntastic         # syntax highlighting
          vim-gitgutter     # shows git changes

          # language specific
          vim-nix           # nix support
          vim-polyglot      # multilingual support
          markdown-preview-nvim # markdown previewer

          # visual
          vim-devicons      # icons for nerdtree
          lightline-vim     # status bar
          gruvbox-nvim      # theme
        ] ++ [
          vim-better-whitespace   # shows tailing whitespaces
          vim-hexedit             # edit file in hex mode
        ];

        opt = [
        ];
      };
    };
  };
}
