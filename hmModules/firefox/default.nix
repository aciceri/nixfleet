{pkgs, ...}: {
  programs.firefox = {
    enable = true;
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
}
