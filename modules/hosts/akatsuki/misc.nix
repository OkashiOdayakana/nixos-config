{
  flake.modules.nixos.host_akatsuki =
    { ... }:
    {
      services.qemuGuest.enable = true;
    };
}
