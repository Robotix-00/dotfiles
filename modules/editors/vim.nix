{ pkgs, ... }:
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
          nerdtree
          vim-commentary
          indentLine

          rainbow
	        lightline-vim
	        syntastic
          vim-nix
          ale
          vim-polyglot

          vim-markdown
          markdown-preview-nvim

        ];
        opt = [];
      };
    };
  };
}
