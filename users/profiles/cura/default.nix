{ pkgs, ... }:
{
  home.packages = with pkgs; [ ] ++
    (if !stdenv.hostPlatform.isAarch64 then [
      cura #  cura is currently broken on aarch64
    ] else [ ]);
  home.sessionVariables = {
    QT_QPA_PLATFORM = "xcb";
  };
}
