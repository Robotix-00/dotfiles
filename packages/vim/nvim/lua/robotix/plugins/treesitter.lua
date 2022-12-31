require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "python", "nix" },
  parser_install_dir = "/home/bruno/parsers",
  highlight = {
    enable = true,
  },
}
