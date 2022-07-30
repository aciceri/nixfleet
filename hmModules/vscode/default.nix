{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # For a few reasons sometimes I'm forced to use VSCode and I don't have time to nixifiy even its configuration.
    # This is why I'm using the FHS version. Purity gods, forgive me!
    package = pkgs.vscode-fhs;
  };
}
