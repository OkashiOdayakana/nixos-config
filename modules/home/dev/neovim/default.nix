{
  flake.modules.homeManager.neovim =
    { inputs, pkgs, ... }:

    {

      imports = [
        inputs.nixvim.homeModules.nixvim
      ];
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        nixpkgs.useGlobalPackages = true;
        extraPackages = with pkgs; [
          nixfmt-rfc-style
        ];

        performance = {
          byteCompileLua.enable = true;
        };

        colorschemes.catppuccin = {
          enable = true;
        };
      };
    };
}
