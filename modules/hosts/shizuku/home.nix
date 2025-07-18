{ config, ... }:
{
  flake.modules.homeManager.host_shizuku = {
    home.stateVersion = "24.05";
    imports = with config.flake.modules.homeManager; [

      neovim
    ];
  };
}
