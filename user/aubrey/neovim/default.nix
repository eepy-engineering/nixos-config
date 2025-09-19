{
  pkgs,
  inputs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins =
      with pkgs.vimPlugins;
      let
        spade-nvim = pkgs.vimUtils.buildVimPlugin {
          name = "spade-nvim";
          src = inputs.spade-nvim;
        };
      in
      [
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        plenary-nvim
        gruvbox-material
        mini-nvim
        telescope-nvim
        spade-nvim
        rustaceanvim
      ];

    extraLuaConfig =
      let
        grammarsPath = pkgs.symlinkJoin {
          name = "nvim-treesitter-grammars";
          paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        };
      in
      ''
        -- also make sure to append treesitter since it bundles some languages
        vim.opt.runtimepath:append("${pkgs.vimPlugins.nvim-treesitter}")
        -- append all *.so files
        vim.opt.runtimepath:append("${grammarsPath}")
      ''
      + builtins.readFile ./neovim.lua;
    extraConfig = builtins.readFile ./neovim.vimrc;
  };
}
