{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nerd-fonts.blex-mono
        nerd-fonts.iosevka
        nerd-fonts.symbols-only
      ];
    };
}
