{ pkgs, ... }:
{
  home.packages = [
    (
      let
        cura5 = pkgs.appimageTools.wrapType2 rec {
          name = "cura5";
          version = "5.8.0";
          src = pkgs.fetchurl {
            url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
            hash = "sha256-EojVAe+o43W80ES5BY3QgGRTxztwS+B6kIOfJOtULOg=";
          };
        };
      in
      pkgs.writeScriptBin "cura" ''
        #! ${pkgs.bash}/bin/bash
        # AppImage version of Cura loses current working directory and treats all paths relateive to $HOME.
        # So we convert each of the files passed as argument to an absolute path.
        # This fixes use cases like `cd /path/to/my/files; cura mymodel.stl anothermodel.stl`.
        args=()
        for a in "$@"; do
          if [ -e "$a" ]; then
            a="$(realpath "$a")"
          fi
          args+=("$a")
        done
        QT_QPA_PLATFORM=xcb exec "${cura5}/bin/cura5" "''${args[@]}"
      ''
    )
  ];
}
