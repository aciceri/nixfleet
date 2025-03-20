{
  pkgs,
  ...
}:
let
  mkExtension = shortId: uuid: {
    name = uuid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };
in
{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.tridactyl-native ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      HardwareAcceleration = true;
      FirefoxHome = {
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = false;
      };
      FirefoxSuggest = {
        WebSuggestions = true;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"
      HttpsOnlyMode = "force_enabled";
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = true;
      DefaultDownloadDirectory = "\${home}/Downloads";
      PromptForDownloadLocation = false;
      RequestedLocales = "en-US";

      ExtensionSettings = builtins.listToAttrs [
        (mkExtension "ublock-origin" "uBlock0@raymondhill.net")
        (mkExtension "tridactyl-vim" "tridactyl.vim@cmcaine.co.uk")
        (mkExtension "styl-us" "7a7a4a92-a2a0-41d1-9fd7-1e92480d612d")
      ];
    };
    profiles.default = {
      search.force = true;
      search.default = "Google";
      search.engines = {
        "Searx" = {
          urls = [
            {
              template = "https://search.aciceri.dev/search";
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
      bookmarks = [ ];
      extensions = [ ];
      userChrome = builtins.readFile ./userchrome.css;
    };
  };

  xdg.configFile."tridactyl/tridactylrc".text = ''
    set editorcmd emacsclient -c %f

    colors catppuccin
  '';

  xdg.configFile."tridactyl/themes/catppuccin.css" = {
    source = ./catppuccin.css;
  };
}
