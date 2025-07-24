{
  flake.modules.homeManager.neovim = {
    programs.nixvim.plugins = {
      mini = {
        enable = true;
        modules.icons = { };
        mockDevIcons = true;
      };
      mini-icons = {
        enable = true;
        mockDevIcons = true;
      };
      blink-cmp = {
        enable = true;
        settings = {
          appearance = {
            nerd_font_variant = "normal";
          };
          completion = {
            accept = {
              auto_brackets = {
                enabled = true;
              };
            };
            documentation = {
              auto_show = true;
            };
          };
          keymap = {
            preset = "super-tab";
          };
          signature = {
            enabled = true;
          };
        };
      };
    };
  };
}
