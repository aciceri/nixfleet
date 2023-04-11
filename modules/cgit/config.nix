{
  lib,
  pkgs,
  ...
}: let
  repos-path = "/var/lib/cgit-repos";
  cgit-setup-repos =
    pkgs.writers.writePython3 "cgit-setup-repos" {
      libraries = with pkgs.python3Packages; [PyGithub];
    } ''
      from github import Github
      from pathlib import Path

      c = Path("${repos-path}")
      c.unlink(missing_ok=True)

      with open(c, "w") as f:
          for repo in Github().get_user("aciceri").get_repos():
              f.writelines([
                  f"repo.url={repo.name}\n"
                  f"repo.path=/home/ccr/projects/aciceri/{repo.name}/.git\n"
                  f"repo.desc={repo.description}\n"
              ])
    '';
in {
  services.nginx.virtualHosts."git.aciceri.dev" = {
    cgit = {
      enable = true;
      css = "/custom.css";
      # scan-path = "/home/ccr/projects/aciceri";
      virtual-root = "/";
      cache-size = 1000;
      include = [
        (builtins.toString (pkgs.writeText "cgit-extra" ''
          source-filter=${pkgs.cgit-pink}/lib/cgit/filters/syntax-highlighting.py
          about-filter=${pkgs.cgit-pink}/lib/cgit/filters/about-formatting.sh
        ''))
        repos-path
      ];
    };
    forceSSL = true;
    enableACME = true;
    # locations."/" = {
    #   proxyPass = "http://127.0.0.1:${builtins.toString config.services.hydra.port}";
    # };
  };

  systemd.services.cgit-setup-repos = {
    description = "Update GitHub personal repos for cgit";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    wantedBy = ["multi-user.target"];
    script = builtins.toString cgit-setup-repos;
  };
}
