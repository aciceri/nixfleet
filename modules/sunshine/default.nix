{
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];

    # displayManager.gdm.enable = true;
    # displayManager.defaultSession = "gnome";

    # displayManager.autoLogin.enable = true;
    # displayManager.autoLogin.user = "sunshine"; # user must exists

    # desktopManager.gnome.enable = true;
  };

  users.users.sunshine = {
    isSystemUser = true;
    group = "sunshine";
  };

  users.groups.sunshine = {};
}
