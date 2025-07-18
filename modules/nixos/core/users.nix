{
  flake.modules.nixos.core =
    { config, pkgs, ... }:
    {
      programs.fish.enable = true;
      sops.secrets.okashi-pwd = {
        sopsFile = ./_secrets/okashi-pwd;
        format = "binary";
        neededForUsers = true;
      };
      users = {
        mutableUsers = false;

        users = {
          okashi = {
            isNormalUser = true;
            extraGroups = [
              "wheel"
              "video"
              "render"
              "audio"
            ];

            shell = pkgs.fish;

            hashedPasswordFile = config.sops.secrets.okashi-pwd.path;
          };
        };
      };
    };
}
