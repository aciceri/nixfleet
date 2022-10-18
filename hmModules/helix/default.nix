{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      editor = {
        indent-guides.render = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
