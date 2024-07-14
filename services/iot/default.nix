{ pkgs, ... }:
{
  imports = [
    ./iot-web.nix
    ./frigate.nix
    ./home-assistant.nix
  ];
}
