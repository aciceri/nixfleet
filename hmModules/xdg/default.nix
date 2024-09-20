{ pkgs, ... }:
{
  xdg = {
    enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
    desktopEntries = {
      org-protocol = {
        name = "org-protocol";
        genericName = "Org protocol";
        exec = "emacsclient -- %u";
        terminal = false;
        mimeType = [ "x-scheme-handler/org-protocol" ];
      };
      firefox = {
        name = "firefox";
        genericName = "Firefox protocol";
        exec = "firefox -- %U";
        terminal = false;
        mimeType = [
          "text/html"
          "text/xml"
          "text/uri"
        ];
      };
    };
  };
  home.packages = [ pkgs.xdg-utils ];
}
