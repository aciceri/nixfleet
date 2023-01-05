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
          enableFXCastBridge = true;
        };
      };
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      https-everywhere
      privacy-badger
      ublock-origin
      tridactyl
      octotree
      octolinker
      org-capture
      browserpass
      bypass-paywalls-clean
      ghosttext # or edit-with-emacs?
      # fx_cast # TODO make PR to rycee NUR repo
    ];
    profiles.ccr = {
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
    };
  };
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
    NIXOS_OZONE_WL = 1;
  };
}
