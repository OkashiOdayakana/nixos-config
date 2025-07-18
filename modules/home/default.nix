{config, inputs, ...}:
{
  flake.modules.homeManager.core =
    { lib, ... }:
    {
      imports = with config.flake.modules.homeManager; [
	shell
	inputs.catppuccin.homeModules.catppuccin
      ];
      programs.home-manager.enable = true;
      # See https://ohai.social/@rycee/112502545466617762
      # See https://github.com/nix-community/home-manager/issues/5452
      systemd.user.startServices = "sd-switch";

      home = {
        username = lib.mkDefault "okashi";
        homeDirectory = lib.mkDefault "/home/okashi";
      };

      services = {
        home-manager.autoExpire = {
          enable = true;
          frequency = "weekly";
          store.cleanup = true;
        };
        gpg-agent = {
          enable = true;
          enableSshSupport = true;
        };
      };
    };
}
