{ config, ... }:
{
  flake.modules.homeManager.host_athena =
    { pkgs, ... }:
    {
      home.stateVersion = "25.05";
      imports = with config.flake.modules.homeManager; [
        desktop
        terminal
        neovim
      ];
      home.packages = [ pkgs.signal-desktop-bin ];
    };
}
