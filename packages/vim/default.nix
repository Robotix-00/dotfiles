{ pkgs, stable, lib, ... }:
let
  vim-hexedit = pkgs.vimUtils.buildVimPlugin {
    name = "vim-hexedit";
    src = pkgs.fetchFromGitHub {
      owner = "rootkiter";
      repo = "vim-hexedit";
      rev = "174dd836d49b0bd785647f0730ad4f98ad101377";
      sha256 = "sha256-tniUeTt9odzHHFTIcPPbVstnQMBcHvWA1FMrr9vj/TA=";
    };
  };

  vimbegood = pkgs.vimUtils.buildVimPlugin {
    name = "vimbegood";
    src = pkgs.fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "vim-be-good";
      rev = "c290810728a4f75e334b07dc0f3a4cdea908d351";
      sha256 = "sha256-lJNY/5dONZLkxSEegrwtZ6PHYsgMD3nZkbxm6fFq3vY=";
    };
  };

  myConfig = pkgs.vimUtils.buildVimPlugin {
    name = "my-config";
    src = ./nvim;
  };
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    defaultEditor = true;

    configure = {
      customRC = ''
        lua require("robotix")
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          myConfig          # TODO
          nerdtree          # file navigation
          telescope-nvim    # file fuzzy finding
          vim-commentary    # comment shortcuts
          indentLine        # shows lines for indent scopes
          vim-visual-multi  # multi line edits
          vim-tmux-navigator
          vim-surround      # surround word with characters #TODO
          # vim-better-whitespace #BROKEN shows tailing whitespaces

          nvim-treesitter
          nvim-treesitter-context

          vimbegood

          # code completion
          nvim-cmp
          cmp-buffer
          cmp-path
          cmp-nvim-lsp
          luasnip
          cmp_luasnip
          friendly-snippets
          lspkind-nvim

          # lsp
          nvim-lspconfig    # TODO

          # formatting & linting
          # null-ls-nvim    # TODO
          syntastic         # syntax highlighting

          # git integration
          vim-gitgutter     # shows git changes
          vim-fugitive

          # language specific
          vim-nix           # nix support
          markdown-preview-nvim # markdown previewer

          # visual
          vim-devicons      # icons for nerdtree
          lightline-vim     # status bar
          gruvbox-nvim      # theme
          vim-better-whitespace   # shows tailing whitespaces
        ];

        opt = [
          vim-hexedit             # edit file in hex mode
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    # lsp servers
    pylint
    rnix-lsp
    haskell-language-server

    cargo
    rustc
    rust-analyzer
  ];
}
