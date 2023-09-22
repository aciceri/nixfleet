{
  config,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "dracula";
      editor = {
        indent-guides.render = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        true-color = true; # to make colors coherent when in ssh
      };
    };
  };
  # home.sessionVariables.EDITOR = lib.mkForce "${config.programs.helix.package}/bin/helix";
  # programs.nushell.environmentVariables.EDITOR = lib.mkForce config.home.sessionVariables.EDITOR;
}
