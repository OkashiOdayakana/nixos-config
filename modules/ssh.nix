{ ... }:
{
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
  users.users."okashi".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFzUJd+GxUUCF4CHw8/iNdtCPxXryB5YddAOOKdKJqb"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICg0LR/wRp0hvyYV1emWVWdIsG5nOFdGg9U9N/HON23I"
  ];
}
