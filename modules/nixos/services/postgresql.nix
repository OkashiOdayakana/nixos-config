{
  flake.modules.nixos.postgresql =
    { pkgs, ... }:
    {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_16;
        enableTCPIP = true;
        authentication = pkgs.lib.mkOverride 10 ''
          #type database  DBuser  auth-method
          local all all trust
        '';
      };
    };
}
