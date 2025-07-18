{ inputs, ... }:
{
  flake.modules.nixos.sops =
    { config, ... }:
    let
      inherit (config.networking) hostName;
    in
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];
      sops = {
        defaultSopsFile = ../../../secrets/${hostName}/secrets.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
    };
}
