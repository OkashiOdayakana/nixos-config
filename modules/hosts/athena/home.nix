{ config, ... }:
{
  flake.modules.homeManager.host_athena = {
    home.stateVersion = "25.05";
    imports = with config.flake.modules.homeManager; [
      desktop
      terminal
      neovim
    ];
  };
}
