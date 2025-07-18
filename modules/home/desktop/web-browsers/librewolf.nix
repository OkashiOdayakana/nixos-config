{
  flake.modules = {
    homeManager.desktop =
      { pkgs, ... }:
      {
        catppuccin.librewolf.profiles.default.enable = false;
        programs.librewolf = {
          enable = true;
          settings = {
            "webgl.disabled" = false;
            "privacy.resistFingerprinting" = false;
            "privacy.clearOnShutdown.history" = false;
            "privacy.clearOnShutdown.cookies" = false;
            "network.cookie.lifetimePolicy" = 0;
          };

          profiles.default = {
            id = 0;
            isDefault = true;
            name = "Default";

            search = {
              default = "Kagi";
              force = true;
              engines = {

                "Kagi" = {
                  icon = "https://kagi.com/favicon.ico";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@k" ];
                  urls = [
                    {
                      template = "https://kagi.com/search";
                      params = [
                        {
                          name = "q";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                };
                "autonomous-system-number-search" = {
                  urls = [ { template = "https://bgp.tools/search?q={searchTerms}"; } ];
                  icon = "https://bgp.tools/favicon-32x32.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@asn" ];
                };

                "nix-packages" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];

                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };

                "nixpkgs-prs" = {
                  urls = [ { template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}"; } ];
                  icon = "https://nixos.org/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@npr" ];
                };

                "nixos-wiki" = {
                  urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
                  icon = "https://wiki.nixos.org/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@nw" ];
                };

                "noogle-dev-search" = {
                  urls = [ { template = "https://noogle.dev/?term=%22{searchTerms}%22"; } ];
                  icon = "https://noogle.dev/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [
                    "@ngd"
                    "@nog"
                  ];
                };

                "bing".metaData.hidden = true;
                "duckduckgo".metaData.hidden = true;
                "amazon".metaData.hidden = true;
                "ebay".metaData.hidden = true;
                "google".metaData.alias = "@g";
              };
            };
            settings = {
              "webgl.disabled" = false;
              "privacy.resistFingerprinting" = false;
              "privacy.clearOnShutdown.history" = false;
              "privacy.clearOnShutdown.cookies" = false;
              "network.cookie.lifetimePolicy" = 0;
            };
          };
        };
      };
  };
}
