{ ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Fira Code";
      size = 12;
    };
    settings = {
      disable_ligatures = "cursor";
      confirm_os_window_close = 0;
    };
    theme = "Snazzy";
    #     extraConfig = ''
    #       include ${pkgs.writeText "custom-kitty-theme" ''
    # # vim:ft=kitty

    # background            #252D30
    # foreground            #ABB2BF
    # cursor                #ABB2BF
    # selection_background  #636C6E

    # #: black
    # color0 #16181A
    # color8 #818b95

    # #: red
    # color1 #D05C65
    # color9 #e7adb2

    # #: green
    # color2  #7DA869
    # color10 #bdd3b3

    # #: yellow
    # color3  #D5B06B
    # color11 #ead7b4

    # #: blue
    # color4  #519FDF
    # color12 #A8CFEE

    # #: magenta
    # color5  #B668CD
    # color13 #DAB3E6

    # #: cyan
    # color6  #46A6B2
    # color14 #a0D3DA

    # #: white
    # color7  #ABB2BF
    # color15 #d4D8DF
    # selection_foreground #636C6E
    #       ''}
    #     '';
  };
}
