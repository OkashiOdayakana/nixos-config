{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.shell.enableFishIntegration = true;
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
          set --universal pure_enable_single_line_prompt true
          set --universal pure_enable_nixdevshell true
          abbr --add cat bat -pp
        '';
        plugins = with pkgs.fishPlugins; [
          {
            name = "autopair";
            src = autopair.src;
          }
          {
            name = "fzf-fish";
            src = fzf-fish.src;
          }
          {
            name = "colored-man-pages";
            src = colored-man-pages.src;
          }
          {
            name = "pure";
            src = pure.src;
          }
        ];
      };
    };
}
