{pkgs, ...}: {
  services.xserver = {
    enable = true;
    autorun = false;
    libinput.enable = true;
    displayManager.startx.enable = true;
  };

  hardware.opengl.enable = true;

  home-manager.users.ccr.home.file.".xinitrc".text = ''
    # Disable access control for the current user.
    xhost +SI:localuser:$USER

    # Make Java applications aware this is a non-reparenting window manager.
    export _JAVA_AWT_WM_NONREPARENTING=1

    # Set default cursor.
    xsetroot -cursor_name left_ptr

    # Set keyboard repeat rate.
    xset r rate 200 60

    # Uncomment the following block to use the exwm-xim module.
    #export XMODIFIERS=@im=exwm-xim
    #export GTK_IM_MODULE=xim
    #export QT_IM_MODULE=xim
    #export CLUTTER_IM_MODULE=xim

    # Lockscreen
    exec ${pkgs.xss-lock}/bin/xss-lock -- ${pkgs.i3lock-blur}/bin/i3lock-blur &

    # Finally start Emacs
    exec emacsclient --eval "(exwm-init)" --create-frame -F "((fullscreen . fullboth))"
  '';
}
