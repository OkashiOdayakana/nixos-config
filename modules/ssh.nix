{ ... }:
{
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = "no";
      KexAlgorithms = [
        "sntrup761x25519-sha512@openssh.com"
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
      ];
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
  ];
}
