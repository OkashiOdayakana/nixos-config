{
  config,
  inputs,
  ...
}:
{
  nixosHosts.shizuku = {
    tailscale-ip6 = "fd7a:115c:a1e0::8f01:607e";
  };

  flake.modules.nixos.host_shizuku = {
    system.stateVersion = "24.05";

    imports = with config.flake.modules.nixos; [
      server
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.ucodenix.nixosModules.default
      jellyfin
      postgresql
      ntp-client
      calibre
      podman
      victoriametrics
      ./_nixos
    ];

  };
}
