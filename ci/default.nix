{inputs, ...}: {
  imports = [
    inputs.hercules-ci-effects.flakeModule
  ];
  herculesCI.ciSystems = [
    "x86_64-linux"
    # "aarch64-linux"
  ];
  hercules-ci.flake-update = {
    enable = true;
    updateBranch = "updated-flake-lock";
    createPullRequest = true;
    autoMergeMethod = "rebase";
    baseMerge = {
      enable = true;
      method = "rebase";
    };
    when = {
      minute = 45;
      hour = 13;
      dayOfWeek = ["Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"];
    };
  };
}
