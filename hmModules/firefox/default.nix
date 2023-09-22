{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package =
      (pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          ExtensionSettings = {};
        };
      })
      .override {
        cfg = {
          enableTridactylNative = true;
          enableBrowserpass = true;
          enableFXCastBridge = pkgs.system == "x86_64-linux";
        };
      };
    profiles.ccr = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        privacy-badger
        ublock-origin
        tridactyl
        browserpass
        # bypass-paywalls-clean
        ghosttext # or edit-with-emacs?
      ];
      settings = {
        "browser.startup.homepage" = "https://google.it";
        "browser.search.region" = "IT";
        "browser.search.isUS" = false;
        "distribution.searchplugins.defaultLocale" = "it-IT";
        "general.useragent.locale" = "it-IT";
        "browser.bookmarks.showMobileBookmarks" = true;
        "browser.download.folderList" = 2;
        "browser.download.lastDir" = "/home/ccr/downloads/";
        "browser.shell.checkDefaultBrowser" = false;
      };
      search.force = true;
      search.default = "Google";
      search.engines = {
        "Searx" = {
          urls = [
            {
              template = "https://search.privatevoid.net/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
        "Google IT" = {
          urls = [
            {
              template = "https://www.google.it/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
      };
    };
  };
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
    NIXOS_OZONE_WL = 1;
  };
}
