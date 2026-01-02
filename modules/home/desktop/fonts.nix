{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      fonts = {
        fontconfig.enable = true;
      };
      home.packages = with pkgs; [
        nerd-fonts.blex-mono
        nerd-fonts.iosevka
        nerd-fonts.symbols-only
        noto-fonts-cjk-sans
        noto-fonts
        noto-fonts-color-emoji
        proggyfonts
      ];

    };
}
