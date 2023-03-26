{age, ...}: {
  imports = [
    ./git-workspace-program.nix
    ./git-workspace-service.nix
  ];

  programs.git-workspace.enable = true;
  services.git-workspace = {
    enable = true;
    frequency = "04:00:00";
    environmentFile = age.secrets.git-workspace-tokens.path;
    workspaces = {
      aciceri = {
        provider = [
          {
            provider = "github";
            name = "aciceri";
            path = "/home/ccr/projects";
            skips_forks = false;
          }
        ];
      };
      mlabs = {
        provider = [
          {
            provider = "github";
            name = "mlabs-haskell";
            path = "/home/ccr/projects";
            skip_forks = false;
          }
        ];
      };
      ethereansos = {
        provider = [
          {
            provider = "github";
            name = "EthereansOS";
            path = "/home/ccr/projects";
            skip_forks = false;
          }
        ];
      };
    };
  };
}
