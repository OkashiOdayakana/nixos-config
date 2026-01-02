{
  flake.modules.nixos.host_shizuku =
    { pkgs, ... }:
    {
      virtualisation = {
        # Incus virtualization
        incus = {
          enable = true;
          ui.enable = true; # Enable web UI
          preseed = {
            networks = [
              {
                name = "incusbr0";
                type = "bridge";
                config = {
                  "ipv4.address" = "10.0.100.1/24";
                  "ipv4.nat" = "true";
                };
              }
            ];
            profiles = [
              {
                name = "default";
                devices = {
                  eth0 = {
                    name = "eth0";
                    network = "incusbr0";
                    type = "nic";
                  };
                  root = {
                    path = "/";
                    pool = "btrfs-incus";
                    type = "disk";
                  };
                };
              }
            ];
          };
        };

        # Also enable libvirtd for virt-manager
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
          };
        };
      };

      users.users.okashi = {
        extraGroups = [
          # ... existing groups ...
          "incus-admin" # Access to Incus management
          "libvirtd" # Access to libvirt
        ];
      };

      environment.systemPackages = with pkgs; [
        # Virtualization packages
        qemu_kvm # QEMU with KVM support
        virt-manager # GUI for VM management
        libvirt # libvirt client tools
        bridge-utils # Network bridge utilities
      ];

      services.caddy.virtualHosts."incus.okashi-lan.org" = {
        extraConfig = ''
          encode {
              zstd better
          }
          import tls_settings
          reverse_proxy [::1]:7443 {
            transport http {
                tls_insecure_skip_verify
                tls_client_auth /var/lib/caddy/incus-client.crt /var/lib/caddy/incus-client.key
            }
          }
        '';
      };

    };
}
