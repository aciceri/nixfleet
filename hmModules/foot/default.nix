{
  config,
  lib,
  ...
}: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";

        font = "Fira Code:size=11";
        dpi-aware = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  # without `--login-shell` PATH isn't well configured (it's inherited from the "systemd shell")
  systemd.user.services.foot.Service.ExecStart = lib.mkForce "${config.programs.foot.package}/bin/foot --server  --login-shell";
}
