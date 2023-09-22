{pkgs, ...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        colorArg = "always";
        useConfig = false;
        # pager = "${pkgs.diff-so-fancy}/bin/diff-so-fancy";
        pager = "${pkgs.delta}/bin/delta --dark --paging=never";
      };
    };
  };
}
