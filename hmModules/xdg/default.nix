{
  xdg = {
    enable = true;
    mimeApps.enable = true;
    desktopEntries = {
      org-protocol = {
        name = "org-protocol";
        genericName = "Org protocol";
        exec = "emacsclient -- %u";
        terminal = false;
        mimeType = ["x-scheme-handler/org-protocol"];
      };
    };
  };
}
