{
  flake.modules.nixos.laptop =
    { ... }:
    {
      services.tuned = {
        enable = true;
        settings = {
          dynamic_tuning = true;
        };
      };
    };
}
