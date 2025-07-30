{
  flake.modules.homeManager.neovim = {
    programs.nixvim = {
      globals = {

        have_nerd_font = true;
      };

      clipboard = {
        providers = {
          wl-copy.enable = true;
        };

        # Sync clipboard between OS and Neovim
        #  Remove this option if you want your OS clipboard to remain independent.
        #register = "unnamedplus";
      };
      opts = {
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

        #autoindent = true;

        formatexpr = "v:lua.require'conform'.formatexpr()";
        breakindent = true;
        expandtab = true;
        signcolumn = "yes";

        hlsearch = true;
        smoothscroll = true;

        confirm = true;

        # Configure how new splits should be opened
        splitright = true;
        splitbelow = true;

        # Sets how neovim will display certain whitespace characters in the editor
        #  See `:help 'list'`
        #  and `:help 'listchars'`
        list = true;
        # NOTE: .__raw here means that this field is raw lua code
        listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

        # Preview substitutions live, as you type!
        inccommand = "split";

        # Show which line your cursor is on
        cursorline = true;

        # Minimal number of screen lines to keep above and below the cursor.
        scrolloff = 10;

      };
    };
  };
}
