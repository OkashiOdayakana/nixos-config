{ config, pkgs, ... }:

let

  veth = "veth-vpn";
  hostIp = "10.0.0.1/24";
  guestIp = "10.0.0.2/24";

in

{

  # https://mth.st/blog/nixos-wireguard-netns/
  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      PrivateNetwork = true;
      PrivateMounts = false;
      ExecStart = "${pkgs.writers.writeDash "netns-up" ''
        ${pkgs.iproute}/bin/ip netns add $1
        ${pkgs.utillinux}/bin/umount /var/run/netns/$1
        ${pkgs.utillinux}/bin/mount --bind /proc/self/ns/net /var/run/netns/$1
      ''} %I";
      ExecStop = "${pkgs.iproute}/bin/ip netns del %I";
    };
  };

  systemd.services."wireguard-wg0" = {
    bindsTo = [ "netns@vpn.service" ];
    after = [ "netns@vpn.service" ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.0.0.2/32" ];
      privateKeyFile = config.sops.secrets."vpn/protonvpn/privateKey".path;
      socketNamespace = "init";
      interfaceNamespace = "vpn";
      peers = [
        {
          publicKey = "gU9CLkRxLUarj9+MtswvE/2Tvclx32w5aoSYeY3eEX8=";
          # Forward all traffic via VPN.
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "163.5.171.2:51820";
          persistentKeepalive = 15;
        }
      ];
    };
  };

  systemd.services.${veth} =
    let
      ns = "vpn";
      ipHost = "${pkgs.iproute}/bin/ip";
      ipGuest = "${ipHost} netns exec ${ns} ${pkgs.iproute}/bin/ip";
    in
    {
      description = "Veth interface for download";
      bindsTo = [ "netns@${ns}.service" ];
      after = [ "netns@${ns}.service" ];
      wantedBy = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writers.writeDash "veth-up" ''
          ${ipHost} link add ${veth} type veth peer name veth1 netns ${ns}
          ${ipHost} addr add ${hostIp} dev ${veth}
          ${ipHost} link set dev ${veth} up
          ${ipGuest} addr add ${guestIp} dev veth1
          ${ipGuest} link set dev veth1 up
        '';
        ExecStop = pkgs.writers.writeDash "veth-down" ''
          ${ipHost} link del ${veth}
        '';
      };
    };

  systemd.services."container@download" = {
    bindsTo = [ "${veth}.service" ];
    after = [ "${veth}.service" ];
  };

  containers.transmission = {
    autoStart = true;
    extraFlags = [ "--network-namespace-path=/run/netns/vpn" ];

    bindMounts = {
      "/etc/resolv.conf" = {
        hostPath = toString (
          pkgs.writeText "resolv.conf" ''
            nameserver 9.9.9.9
            nameserver 1.1.1.1
          ''
        );
        isReadOnly = true;
      };

    };

    config =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          wireguard-tools
          traceroute
          ldns
        ];
        system.stateVersion = "24.05";
      };
  };

  services.transmission = {
    enable = true; # Enable transmission daemon
    package = pkgs.transmission_4;
    openRPCPort = true; # Open firewall for RPC
    credentialsFile = config.sops.secrets."media/transmission/creds.json".path;
    settings = {
      # Override default settings
      rpc-bind-address = "10.0.0.2";
      rpc-whitelist-enabled = false;
      rpc-authentication-required = true;
      download-dir = "/Nas-main/torrent-media/Torrents";
      incomplete-dir = "/Nas-main/torrent-media/Torrents/.incomplete";
    };
  };

  systemd.services."transmission" = {
    bindsTo = [ "wireguard-wg0.service" ];
    after = [
      "wireguard-wg0.service"
      "netns@vpn.service"
      "${veth}.service"
    ];
    unitConfig.JoinsNamespaceOf = "netns@vpn.service";
    serviceConfig = {
      Type = "simple";
      PrivateNetwork = true;
      BindReadOnlyPaths =
        let
          resolv = pkgs.writeText "resolv.conf" ''
            nameserver 9.9.9.9
            nameserver 1.1.1.1
          '';
        in
        [ "${resolv}:/etc/resolv.conf" ];
      BindPaths = [ "/Nas-main/torrent-media" ];
    };
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [ "veth-vpn" ];
    externalInterface = "enp5s0";
    forwardPorts = [
      {
        sourcePort = 9091;
        proto = "tcp";
        destination = "10.0.0.2:9091";
      }
    ];
  };
}
