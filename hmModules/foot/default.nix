{
  lib,
  config,
  ...
}:
lib.mkMerge [
  {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-direct";
          login-shell = "yes";
          dpi-aware = "no";
          horizontal-letter-offset = "1";
          pad = "1x1";
          font =
            let
              size = "13";
            in
            lib.mkForce (
              lib.concatStringsSep ", " [
                "Iosevka Comfy:size=${size}"
                "Symbols Nerd Font:size=${size}"
                "JoyPixels:size=${size}"
              ]
            );
        };
        cursor = {
          blink = true;
        };
        tweak = {
          overflowing-glyphs = true;
        };

        key-bindings = {
          scrollback-up-page = "Control+Shift+k";
          scrollback-down-page = "Control+Shift+j";
          search-start = "Control+Shift+s";
          pipe-command-output = ''[sh -c 'f=$(mktemp); cat - > $f; footclient hx $f; rm $f'] Control+Shift+g'';
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  }
  (lib.mkIf config.programs.fish.enable {
    programs.fish.functions = {
      mark_prompt_start = {
        body = ''echo -en "\e]133;A\e\\"'';
        onEvent = "fish_prompt";
      };
      foot_cmd_start = {
        body = ''echo -en "\e]133;C\e\\"'';
        onEvent = "fish_preexec";
      };
      foot_cmd_end = {
        body = ''echo -en "\e]133;D\e\\"'';
        onEvent = "fish_postexec";
      };
    };
  })
]
