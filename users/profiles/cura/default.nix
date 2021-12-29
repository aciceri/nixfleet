{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cura
  ];
  home.sessionVariables = {
    QT_QPA_PLATFORM = "xcb";
  };
}
