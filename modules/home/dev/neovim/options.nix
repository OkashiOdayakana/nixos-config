{
  flake.modules.homeManager.neovim = {
    programs.nixvim.opts = {
      # Show line numbers
      number = true;

      # Enable mouse mode
      mouse = "a";

      showmode = false;

      # Save undo history
      undofile = true;

      # Case-insensitive search
      ignorecase = true;
      smartcase = true;

      breakindent = true;
      expandtab = true;
      signcolumn = "yes";

      hlsearch = true;
      smoothscroll = true;

      confirm = true;
    };
  };
}
