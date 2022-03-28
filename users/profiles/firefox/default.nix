{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-unwrapped;
    #package = (pkgs.firefox.override { extraNativeMessagingHosts = [
    #  pkgs.browserpass
    #  pkgs.passff-host
    #]; });
    #extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #https-everywhere
    #privacy-badger
    #ublock-origin
    #react-devtools
    #org-capture
    #clearurls
    #browserpass # not working, manually installed passff
    #firefox-color
    #darkreader
    #cookie-autodelete
    # and manually installed ghost-text for atomic-chrome
    #];
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
      userChrome = ''
        /* Hide tab bar in FF Quantum * /
        @-moz-document url("chrome://browser/content/browser.xul") {
          #TabsToolbar {
          visibility: collapse !important;
            margin-bottom: 21px !emportant;
          }

          #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
            visibility: collapse !important;
          }
        }
      '';
      userContent = "";
    };
  };
}
