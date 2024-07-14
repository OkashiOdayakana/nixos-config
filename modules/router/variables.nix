{ lib, ... }:
with lib;
with types;
{
  options = {
    routers = mkOption {
      type = attrs; # Should probably be `submodule, but I'm too lazy today
      description = "My config attrs";
    };
  };
  config = {
    routers = {
      lanIP = "192.168.1.1";
      lanNet = "192.168.1.0/24";
      lanIf = "enp1s0f0";
      wanIf = "enp1s0f1";
      hostname = "Router";
    };
  };
}
