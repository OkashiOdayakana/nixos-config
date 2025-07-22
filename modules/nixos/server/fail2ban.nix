{
  flake.modules.nixos.fail2ban =
    { ... }:
    {
      services.fail2ban = {
        enable = true;
      };
    };
}
