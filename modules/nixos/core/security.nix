{
  flake.modules.nixos.core =
    { lib, config, ... }:
    {

      boot.blacklistedKernelModules = [
        "dccp"
        "sctp"
        "rds"
        "tipc"
      ];

      security = {
        sudo.enable = lib.mkForce false;
        sudo-rs = {
          enable = true;
          execWheelOnly = true;
        };
      };

      services.userborn.enable = true;
    };
}
