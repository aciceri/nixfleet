{pkgs, ...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        colorArg = "always";
        useConfig = true;
        pager = "${pkgs.delta}/bin/delta --dark --paging=never";
      };
    };
  };
}
