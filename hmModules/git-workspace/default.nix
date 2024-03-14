{
  age,
  username,
  ...
}: {
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
            path = "/home/${username}/projects";
            skips_forks = false;
          }
        ];
      };
      mlabs = {
        provider = [
          {
            provider = "github";
            name = "mlabs-haskell";
            path = "/home/${username}/projects";
            skip_forks = false;
          }
        ];
      };
      mlabs-ai = {
        provider = [
          {
            provider = "github";
            name = "mlabs-ai";
            path = "/home/${username}/projects";
            skip_forks = false;
          }
        ];
      };
      ethereansos = {
        provider = [
          {
            provider = "github";
            name = "EthereansOS";
            path = "/home/${username}/projects";
            skip_forks = false;
          }
        ];
      };
      adcazzum = {
        provider = [
          {
            provider = "github";
            name = "adcazzum";
            path = "/home/${username}/projects";
            skip_forks = false;
          }
        ];
      };
    };
  };
}
