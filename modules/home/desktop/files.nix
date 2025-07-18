{
  flake.modules.homeManager.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.file."${config.home.homeDirectory}/.gtkrc-2.0".force = lib.mkForce true;
    };
}
