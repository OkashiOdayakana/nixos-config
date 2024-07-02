{ ...}:
{
    services.thermald.enable = true;
    networking.networkmanager.enable = true;
    services = {
        syncthing = {
            enable = true;
            user = "okashi";
            dataDir = "/home/okashi/Documents";    # Default folder for new synced folders
                configDir = "/home/okashi/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
        };
    };
    networking.firewall.allowedTCPPorts = [ 8384 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];
    users.users.okashi.extraGroups = [ "networkmanager" ];
}
