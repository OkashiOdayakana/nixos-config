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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwZBG6n9ElUn0DppWRM8Dz280E7Jb5RUa1c+lQuu7Rc"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxPNvjWvpG/Vn/OUqJsAL7Be4r2P0EvDJrLxipfzI0+"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ14X0L1gVaexdjTLXY9XUdncsE5HngES/dpEtDHsGGn"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILAyJiCtYCSo86uYBHfp4seiOeMjGEb9esIai8kh3QyW"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHfhItKyPt+nOkBUF6jiIDsjGETqXP6NanNrpRUV2V6"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICy4ZjmkSywM1GKWfr2ixiaHs1ST4tkvS//KcQtAaL/I"
    ];
  };
}
