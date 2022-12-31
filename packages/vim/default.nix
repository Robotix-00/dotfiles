{ pkgs, stable, lib, ... }:
let
  vim-hexedit = pkgs.vimUtils.buildVimPlugin {
    name = "vim-hexedit";
    src = pkgs.fetchFromGitHub {
      owner = "rootkiter";
      repo = "vim-hexedit";
      rev = "refs/tags/v1.0.4";
      sha256 = "sha256-tniUeTt9odzHHFTIcPPbVstnQMBcHvWA1FMrr9vj/TA=";
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
          myConfig
          harpoon           # project file management
          telescope-nvim    # file fuzzy finding
          vim-tmux-navigator# vim-tmux navigation integration

          vim-commentary    # comment shortcuts
          indentLine        # shows lines for indent scopes
          vim-visual-multi  # multi line edits
          vim-surround      # surround word with characters
          vim-better-whitespace   # shows tailing whitespaces


          # code completion
          nvim-treesitter

          nvim-cmp
          cmp-buffer
          cmp-path
          cmp-nvim-lsp
          cmp-git

          # luasnip
          # cmp_luasnip
          # friendly-snippets
          # lspkind-nvim

          # lsp
          nvim-lspconfig    # WIP

          # formatting & linting
          # null-ls-nvim      # WIP
          syntastic         # syntax highlighting

          # git integration
          vim-gitgutter     # shows git changes
          vim-fugitive

          # language specific
          vim-nix               # nix support
          markdown-preview-nvim # markdown previewer

          # visual
          lightline-vim     # status bar
          rose-pine         # theme
        ];

        opt = [
          vim-hexedit             # edit file in hex mode
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    # lsp servers
    python39Packages.python-lsp-server
    rnix-lsp
    haskell-language-server
  ];
}
