{pkgs, ...}: {
  services.xserver = {
    enable = true;
    autorun = true;
    exportConfiguration = true;
    layout = "us";
    xkbModel = "thinkpad";
    xkbVariant = "altgr-intl";
    libinput.enable = true;
    displayManager = {
      defaultSession = "none+exwm";
      autoLogin.enable = true;
      autoLogin.user = "ccr";
      sddm = {
        enable = true;
        autoLogin.relogin = true;
        #background = "#000000";
      };
    };
    desktopManager = {
      xterm.enable = false;
    };
    windowManager = {
      session = pkgs.lib.singleton {
        name = "exwm";
        # TODO query emacs daemon to discover if it's ready to start EXWM)` before starting the session
        start = ''
          exec dbus-launch --exit-with-session emacsclient --create-frame -F "((fullscreen . fullboth))" --eval "(exwm-init)"
        '';
      };
    };
  };

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <${
      pkgs.writeText "Xresources" ''
        Xcursor.theme: Adwaita
        Xcursor.size: 16
        Emacs.Background: black
      ''
    }
  '';

  home-manager.users.ccr = {
    services.network-manager-applet.enable = true;
    services.blueman-applet.enable = true;
    services.pasystray.enable = true;
    xsession.enable = true;
  };

  services.udisks2.enable = true;

  hardware.opengl.enable = true;
}
