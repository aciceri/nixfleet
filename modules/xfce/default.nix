{
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager = {
      defaultSession = "xfce";
      autoLogin.user = "mara";
    };
  };

  home-manager.users.mara.home.file."background-image" = {
    target = ".background-image";
    source = ./mlp.jpg;
  };
}
