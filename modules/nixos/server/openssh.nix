{
  flake.modules.nixos.openssh = {
    services.openssh = {
      enable = true;
      openFirewall = true;

      # require public key authentication for better security
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        PermitRootLogin = "no";
      };
      hostKeys = [
        {
          type = "ed25519";
          path = "/etc/ssh/ssh_host_ed25519_key";
        }
      ];
    };
    users.users."okashi".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICg0LR/wRp0hvyYV1emWVWdIsG5nOFdGg9U9N/HON23I"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILAyJiCtYCSo86uYBHfp4seiOeMjGEb9esIai8kh3QyW"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHfhItKyPt+nOkBUF6jiIDsjGETqXP6NanNrpRUV2V6"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIg35gdoTJZyXBSz251LNTEjEpmuQHtAnr1PozACFvtY"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEP0ZA4VTnpZ1RTzn9AhaNDJNsn+FDoNiVwpiUdnypzdAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBBdKvsEdPQD0ND3UYkrEIM7hSrBe9ECjovFPsbLUlFiAAAABHNzaDo="
    ];
  };
}
